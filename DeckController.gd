extends Node

signal UI_update_completed

var deck = []
var draw_pile = []
var play_pile = []
var discard_pile = []
var burn_pile = []
var sleeve_pile = []
var score = 0
var hitpoints = 100
var max_hitpoints
var shieldpoints = 0
var current_card_effect_id
var chips

#screen positions and spacing
onready var play_pile_pos = $PlayPilePosition.position
onready var discard_pile_pos = $DiscardPilePosition.position
var play_pile_card_spacing = 14
var discard_pile_card_spacing = 4

var cards_currently_moving = []

var Card = preload("res://Card.tscn")

func _ready():
	if name == "Player":
		hitpoints = get_parent().get_parent().player_hitpoints
		max_hitpoints = get_parent().get_parent().player_max_hitpoints
		chips = get_parent().get_parent().player_chips
	elif name == "Opponent":
		hitpoints = get_parent().get_parent().opponent_health_points
		max_hitpoints = hitpoints

func instance_new_card(card_id) -> Object:
	var new_card = Card.instance()
	new_card.call_deferred("set_card_id", card_id)
	
	new_card.connect("card_hover_started", get_parent().get_node("HoverPanel"), "_on_Card_hover_started")
	new_card.connect("card_hover_ended", get_parent().get_node("HoverPanel"), "_on_Card_hover_ended")
	new_card.get_node("MovementHandler").connect("movement_completed", self, "on_card_movement_completed")
	
	return new_card

func add_card_to_deck(card_id):
	#add a defined card to the deck
	deck.append(instance_new_card(card_id))

func build_draw_pile():
	add_cards_to_draw_pile(deck)

func add_cards_to_draw_pile(cards: Array):
	#put array of cards into draw pile
	for card in cards:
		draw_pile.append(card)
		card.position = $DeckDisplay.position
	
	$DeckDisplay.change_deck_size(draw_pile.size())
	shuffle_draw_pile()

func shuffle_draw_pile():
	#randomise draw contents
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in draw_pile.size():
		var random = i + rng.randi_range(0, draw_pile.size() - 1 - i)
		var temp = draw_pile[random]
		draw_pile[random] = draw_pile[i]
		draw_pile[i] = temp

func draw_top_card():
	#draw the top card and enact it's effect
	#check draw_pile has at least 1 card first
	if draw_pile.size() == 0:
		shuffle_discard_pile_into_draw_pile()
		yield(self, "UI_update_completed")
	
	#move top draw pile card to top of play pile
	var top_card = draw_pile[0]
	top_card.score_before_played = score
	#if first time drawn then add it as a child so we can display it
	if top_card.get_parent() == null:
		add_child(top_card)
	move_cards_to([top_card], "draw_pile", "play_pile")
	
	yield(self, "UI_update_completed")
	
	$DeckDisplay.change_deck_size(draw_pile.size())
	
	if top_card.has_special_effect():
		play_card_draw_effect(top_card, top_card.get_card_id())

func shuffle_discard_pile_into_draw_pile():
	#put everything in discard pile into draw pile
	var cards_to_move = []
	#reset card art, suit
	for card in discard_pile:
		card.set_card_art(card.get_card_id()) #reset card art to default
		card.set_card_suit(CardList.card_dictionary[card.get_card_id()].suit)
		cards_to_move.append(card)
	
	#move cards
	move_cards_to(cards_to_move, "discard_pile", "draw_pile")
	
	#wait for cards to finish moving
	yield(self, "UI_update_completed")	
	
	for card in cards_to_move:
		remove_child(card)
	
	shuffle_draw_pile()

func discard_played_cards():
	var cards_to_discard = []
	var cards_to_burn = []
	for card in play_pile:
		if card.card_does_burn:
			cards_to_burn.append(card)
			card.start_burn_animation()
		elif not card.card_locked: #card does not burn, so should be discarded
			cards_to_discard.append(card)
	if cards_to_burn.size() > 0:
		#wait for burn animation
		yield(cards_to_burn[0], "burn_complete")
		#remove cards to burn as children
		for card in cards_to_burn:
			play_pile.erase(card)
			cards_currently_moving.erase(card)
			if card.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
				card.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
			remove_child(card)
	
	if cards_to_discard.size() > 0:
		move_cards_to(cards_to_discard, "play_pile", "discard_pile")
	
		#wait for cards to finish moving
		yield(self, "UI_update_completed")
	
	#move any remaining cards in play pile to starting positions (i.e. locked cards)
	var card_spacing = play_pile_card_spacing
	if name == "Opponent":
		card_spacing = card_spacing * (-1)
	var cards_moved = 0
	for card in play_pile:
		card.get_node("MovementHandler").move_card_to(play_pile_pos + Vector2(card_spacing * (cards_moved), 0))
		#todo: track and reset score before played here
		cards_moved += 1
	
	#set score to 0 since round is over
	score = 0

#func add_card_to_draw_pile(card, position):
#	#add a defined card to the draw pile at a defined position
#	pass

func heal(heal_amount: int, heal_source_pos: Vector2):
	if heal_amount > 0:
		if hitpoints + heal_amount > max_hitpoints:
			hitpoints = max_hitpoints
		else:
			hitpoints += heal_amount
		get_parent().get_node("BattleScene").update_health_points()
		
		#create hearts and then send them toward the heal target
		var skip_count = 3
		var i = 0
		while i < heal_amount: 
			var heart = load("res://HealHeart.tscn").instance()
			heart.position = heal_source_pos
			add_child(heart)
			var target_pos
			if name == "Player":
				target_pos = get_parent().get_node("BattleScene/PlayerSprite").global_position
			elif name == "Opponent":
				target_pos = get_parent().get_node("BattleScene/OpponentSprite").global_position
			heart.set_target_position(target_pos)
			heart.start_tweening_to_target()
			#delay to create spacing between
			var timer = Timer.new()
			add_child(timer)
			timer.wait_time = 0.1
			timer.start()
			yield(timer, "timeout")
			i += skip_count

func damage(damage_amount: int):
	if damage_amount > 0:
		hitpoints -= damage_amount
		get_parent().get_node("BattleScene").play_damage_animation(self, damage_amount)

func move_cards_to(cards: Array, from_pile: String, to_pile: String):
	var other_player
	if name == "Player":
		other_player = get_parent().get_node("Opponent")
	else: 
		other_player = get_parent().get_node("Player")
	#change spacing of cards depending on to_pile
	var target_position = Vector2(0, 0)
	var card_spacing = 0
	if to_pile == "play_pile":
		target_position = play_pile_pos
		card_spacing = play_pile_card_spacing
	elif to_pile == "discard_pile":
		target_position = discard_pile_pos
		card_spacing = discard_pile_card_spacing
	elif to_pile == "draw_pile":
		target_position = $DeckDisplay.position
		card_spacing = 0
	elif to_pile == "other_play_pile":
		target_position = other_player.play_pile_pos
		card_spacing = play_pile_card_spacing
	elif to_pile == "sleeve_pile":
		target_position = $SleevePilePosition.position
		card_spacing = play_pile_card_spacing
	
	if name == "Opponent":
		card_spacing = card_spacing * (-1) #stack in reverse for opponent
	
	for card in cards:
		#add card to an array tracking the cards that are currently moving (to be checked by on_card_movement_completed function
		cards_currently_moving.append(card)
		#add cards to to_pile and move them there
		match to_pile:
			"play_pile":
				play_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(card_spacing * (play_pile.size() - 1), 0))
			"discard_pile":
				discard_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(card_spacing * (discard_pile.size() - 1), 0))
			"draw_pile":
				draw_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(card_spacing * (draw_pile.size() - 1), 0))
			"other_play_pile":
				other_player.play_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(-1 * card_spacing * (other_player.play_pile.size() - 1), 0))
			"sleeve_pile":
				sleeve_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(card_spacing * (sleeve_pile.size() - 1), 0))
		#remove cards from from_pile
		match from_pile:
			"play_pile":
				play_pile.erase(card)
			"discard_pile":
				discard_pile.erase(card)
			"draw_pile":
				draw_pile.erase(card)
			"sleeve_pile":
				sleeve_pile.erase(card)

func on_card_movement_completed(card):
	cards_currently_moving.erase(card)
	get_parent().update_scores() #since cards may have moved into or out of play piles and therefore changed scores
	if cards_currently_moving.size() == 0:
		emit_signal("UI_update_completed")

func _on_Card_choice_to_make(choice_array, card):
	emit_signal("card_choice_to_make", choice_array, card)

func play_card_draw_effect(card, id):
	if self.name == "Opponent": #currently this means opponents are unable to use special cards
		return
	
	current_card_effect_id = id
	
	if id == "001": #ace of spades
		var choice_array = [id, "053"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "014": #ace of clubs
		var choice_array = [id, "056"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "027": #ace of diamonds
		var choice_array = [id, "059"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "040": #ace of hearts
		var choice_array = [id, "062"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "069": #Joker
		if discard_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, discard_pile)
	elif id == "070": #birthday card
		card.set_card_value(card.get_card_value() + 1)
		card.set_card_name(CardList.card_dictionary["070"].name + " (" + str(card.get_card_value()) + ")")
		#add a candle each time card drawn
		var card_value = card.get_card_value()
		var candle = Sprite.new()
		card.add_child(candle)
		candle.texture = load("res://assets/art/candles.png")
		candle.hframes = 5
		candle.frame = round(rand_range(0,4)) #choose a random candle colour
		var spacing = 2
		if not card_value % 2 == 0: #odd
			candle.position = Vector2(27 + spacing * card_value, 51)
		else: 
			candle.position = Vector2(27 - spacing * (card_value - 1), 51)
	elif id == "071": #magic trick card
		var choice_array = ["051", "020"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "072": #Red Joker
		if draw_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, draw_pile)
	elif id == "076": #Get Well Soon card
		get_parent().get_node("Player").heal(10, card.position)
		get_parent().get_node("Opponent").heal(10, card.position)
	elif id == "077": #+2 Card
		get_parent().get_node("Opponent").draw_top_card()
		get_parent().get_node("Opponent").draw_top_card()
	elif id == "078": #Reverse Card
		var opponent = get_parent().get_node("Opponent")
		var player_play_pile = []
		var opponent_play_pile = []
		for card_to_swap in play_pile:
			player_play_pile.append(card_to_swap)
		for card_to_swap in opponent.play_pile:
			opponent_play_pile.append(card_to_swap)
		for card_to_swap in player_play_pile:
			#move card to other player
			move_cards_to([card_to_swap], "play_pile", "other_play_pile")
			yield(self, "UI_update_completed")
			#remove this card as a child and disconnect movement signal
			if card_to_swap.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
				card_to_swap.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
			if is_a_parent_of(card_to_swap):
				remove_child(card_to_swap)
			#add this card as a child of the other player and connect movement signal
			opponent.add_child(card_to_swap)
			card_to_swap.get_node("MovementHandler").connect("movement_completed", opponent, "on_card_movement_completed")
		for card_to_swap in opponent_play_pile:
			opponent.move_cards_to([card_to_swap], "play_pile", "other_play_pile")
			yield(opponent, "UI_update_completed")
			#remove this card as a child and disconnect movement signal
			if card_to_swap.get_node("MovementHandler").is_connected("movement_completed", opponent, "on_card_movement_completed"):
				card_to_swap.get_node("MovementHandler").disconnect("movement_completed", opponent, "on_card_movement_completed")
			if opponent.is_a_parent_of(card_to_swap):
				opponent.remove_child(card_to_swap)
			#add this card as a child of the other player and connect movement signal
			add_child(card_to_swap)
			card_to_swap.get_node("MovementHandler").connect("movement_completed", self, "on_card_movement_completed")
	elif id == "079": #negative ace of spades
		var choice_array = [id, "089"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "090": #negative ace of clubs
		var choice_array = [id, "100"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "101": #negative ace of diamonds
		var choice_array = [id, "111"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "112": #negative ace of hearts
		var choice_array = [id, "122"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "123": #I the Magician
		var card_array = ["071", "071", "071", "001", "040", "145"]
		var new_cards = []
		for new_card_id in card_array:
			var new_card = instance_new_card(new_card_id)
			new_cards.append(new_card)
		add_cards_to_draw_pile(new_cards)
	elif id == "124": #II The High Priestess
		#- reveal the next X cards in your draw pile in order. burns
		pass
	elif id == "125": #III The Empress
		# locks an 11 of hearts to players play pile
		var eleven_of_hearts = instance_new_card("062")
		add_child(eleven_of_hearts)
		add_cards_to_draw_pile([eleven_of_hearts])
		move_cards_to([eleven_of_hearts], "draw_pile", "play_pile")
		eleven_of_hearts.score_before_played = score
		eleven_of_hearts.lock_card()
	elif id == "145": #ace up your sleeve
		var ace_id
		#creates an ace with random suit
		var random_suit_id = randi() % 4 + 1
		match random_suit_id:
			1:
				ace_id = "001"
			2:
				ace_id = "014"
			3:
				ace_id = "027"
			4:
				ace_id = "040"
		move_cards_to([card], "play_pile", "discard_pile") #discard ace up your sleeve card
		
		#move the ace to sleeve pile
		var new_card = Card.instance()
		new_card.add_to_group("sleeve_cards")
		add_child(new_card)
		new_card.set_card_id(ace_id)
		play_pile.append(new_card)
		new_card.connect("card_hover_started", get_parent().get_node("HoverPanel"), "_on_Card_hover_started")
		new_card.connect("card_hover_ended", get_parent().get_node("HoverPanel"), "_on_Card_hover_ended")
		new_card.get_node("MovementHandler").connect("movement_completed", self, "on_card_movement_completed")
		new_card.connect("card_clicked", self, "_on_SleveCard_clicked", [new_card])
		
		move_cards_to([new_card], "play_pile", "sleeve_pile")

func _on_ChoiceController_choice_made_(origin_card, choice_array, choice_index):
	var id = current_card_effect_id
	var choice_made = choice_array[choice_index]
	
	if id == "001" || id == "014" || id == "027" || id == "040" : #aces
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + str(origin_card.get_card_value()) + ")")
	elif id == "069": #Joker
		origin_card.set_card_value(choice_made.get_card_value())
		origin_card.set_card_suit(choice_made.get_card_suit())
		origin_card.set_card_art(choice_made.get_card_id())
		origin_card.set_card_name("Joker (" + choice_made.get_card_name() + ")")
	elif id == "071": #magic trick card
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_suit(CardList.card_dictionary[choice_made].suit)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + CardList.card_dictionary[choice_made].name + ")")
	elif id == "072": #Red Joker
		origin_card.set_card_value(choice_made.get_card_value())
		origin_card.set_card_suit(choice_made.get_card_suit())
		origin_card.set_card_art(choice_made.get_card_id())
		call_deferred("play_card_draw_effect", origin_card, choice_made.get_card_id())
	elif id == "079" || id == "090" || id == "101" || id == "112" : #negative aces
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + str(origin_card.get_card_value()) + ")")
	current_card_effect_id = null

func _on_SleveCard_clicked(card):
	move_cards_to([card], "sleeve_pile", "play_pile")
	play_card_draw_effect(card, card.card_id)

#func play_card_start_of_turn_effect(card, id):
#	if self.name == "Opponent": #currently this means opponents are unable to use special cards
#		return
#
#	current_card_effect_id = id
#
#	if id == "":
#		pass
#
#func play_card_discard_effect(card, id):
#	if self.name == "Opponent": #currently this means opponents are unable to use special cards
#		return
#
#	current_card_effect_id = id
#
#	if id == "":
#		pass
