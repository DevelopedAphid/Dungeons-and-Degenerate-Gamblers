extends Node

signal UI_update_completed
signal swap_completed

var deck = []
var draw_pile = []
var play_pile = []
var discard_pile = []
var burn_pile = []
var sleeve_pile = []
var score = 0
var hitpoints = 100
var max_hitpoints
var decaying_healing = 0
var shieldpoints = 0
var current_card_effect_id
var chips

var rounds_to_skip = 0
#todo: replace these with checks to see if card still in play as all these fail once I bring in a "unlock a card" mechanic
var judgment_shield_active = false
var chariot_effect_active = false
var star_effect_active = false
var devil_effect_active = false
var moon_shroud_effect_active = false
var moon_damage_effect_active = false
var blackjack_cap_type = "none"

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
	new_card.connect("x_value_changed", get_parent().get_parent(), "on_Card_x_value_changed")
	
	return new_card

func build_draw_pile_from_deck(deck_to_build, x_values):
	var draw_pile_to_add = []
	var i = 0
	for n in deck_to_build:
		var new_card = instance_new_card(n)
		new_card.index_in_deck = i
		new_card.x_value = x_values[i]
		i += 1
		draw_pile_to_add.append(new_card)
	
	add_cards_to_draw_pile(draw_pile_to_add)

func add_cards_to_draw_pile(cards: Array):
	#put array of cards into draw pile
	for card in cards:
		draw_pile.append(card)
		card.position = $DeckDisplay.position
	
	$DeckDisplay.change_deck_size(draw_pile.size())
	shuffle_draw_pile()

func add_card_to_draw_pile_at_position(card: Object, pile_pos: int):
	draw_pile.insert(pile_pos, card)
	card.position = $DeckDisplay.position
	$DeckDisplay.change_deck_size(draw_pile.size())

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
	
	for card in play_pile: #play on shuffle effect for any cards locked in play
		play_end_of_shuffle_effect(card, card.card_id)

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
		print(self.name + ": " + str(cards_to_discard))
		discard_cards(cards_to_discard)
		print(self.name + ": now yielding on UI update")
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
	print("finished discarding " + self.name)

func discard_cards(cards_to_discard: Array):
	for card in cards_to_discard:
		move_cards_to([card], "play_pile", "discard_pile")
		play_card_discard_effect(card, card.card_id)
		print("just discarded: " + card.card_name)

func heal(heal_amount: int, heal_source_pos: Vector2):
	if heal_amount > 0:
		if hitpoints + heal_amount > max_hitpoints:
			hitpoints = max_hitpoints
		else:
			hitpoints += heal_amount
		$IDCard.change_hitpoints(hitpoints)
		
		#create hearts and then send them toward the heal target
		var skip_count = 3
		var i = 0
		while i < heal_amount: 
			var heart = load("res://FlyingIcon.tscn").instance()
			heart.set_icon("hearts")
			heart.position = heal_source_pos
			add_child(heart)
			var target_pos
			target_pos = $IDCard/ChipCounter.global_position
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
		$IDCard.change_hitpoints(hitpoints)

func add_spade_shield(shield_amount: int, shield_source_pos: Vector2):
	$IDCard.change_shieldpoints(shield_amount)
	if shield_amount > 0:
		#create diamond and then send them toward the ID Card
		var skip_count = 3
		var i = 0
		while i < shield_amount:
			var spade = load("res://FlyingIcon.tscn").instance()
			spade.set_icon("spades")
			spade.position = shield_source_pos
			add_child(spade)
			var target_pos
			target_pos = $IDCard/ShieldCounter.global_position
			spade.set_target_position(target_pos)
			spade.start_tweening_to_target()
			#delay to create spacing between
			var timer = Timer.new()
			add_child(timer)
			timer.wait_time = 0.1
			timer.start()
			yield(timer, "timeout")
			i += skip_count

func add_chips(chips_to_add: int, chip_source_pos: Vector2):
	if name == "Player":
		chips += chips_to_add
		$IDCard.change_chips(chips)
		#create diamonds and then send them toward the chips target
		var skip_count = 3
		var i = 0
		while i < chips_to_add: 
			var diamond = load("res://FlyingIcon.tscn").instance()
			diamond.set_icon("diamonds")
			diamond.position = chip_source_pos
			add_child(diamond)
			var target_pos
			target_pos = $IDCard/ChipCounter.global_position
			diamond.set_target_position(target_pos)
			diamond.start_tweening_to_target()
			#delay to create spacing between
			var timer = Timer.new()
			add_child(timer)
			timer.wait_time = 0.1
			timer.start()
			yield(timer, "timeout")
			i += skip_count

func move_cards_to(cards: Array, from_pile: String, to_pile: String):
	var other_player
	if name == "Player":
		other_player = get_parent().get_node("Opponent")
	else: 
		other_player = get_parent().get_node("Player")
	
	if moon_shroud_effect_active: #shroud cards in play pile
		if to_pile == "play_pile": #cads moving to play pile should be shrouded
			for card in cards:
				card.shroud_card()
		elif from_pile == "play_pile": #moving out of play_pile we should reveal the card
			for card in cards:
				card.reveal_card()
	
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
	elif to_pile == "other_discard_pile":
		target_position = other_player.discard_pile_pos
		card_spacing = discard_pile_card_spacing * (-1)
	elif to_pile == "other_draw_pile":
		target_position = other_player.get_node("DeckDisplay").position
		card_spacing = 0
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
			"other_discard_pile":
				other_player.discard_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(card_spacing * (other_player.discard_pile.size() - 1), 0))
			"other_draw_pile":
				other_player.draw_pile.append(card)
				card.get_node("MovementHandler").move_card_to(target_position + Vector2(card_spacing * (other_player.draw_pile.size() - 1), 0))
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

func swap_piles(pile_type, pile_1, pile_2):
	var other_player
	if name == "Player":
		other_player = get_parent().get_node("Opponent")
	else:
		other_player = get_parent().get_node("Player")
	var this_player_pile = []
	var other_player_pile = []
	for card_to_swap in pile_1:
		this_player_pile.append(card_to_swap)
	for card_to_swap in pile_2:
		other_player_pile.append(card_to_swap)
	if this_player_pile.size() > 0:
		for card_to_swap in this_player_pile:
			#move card to other player
			move_cards_to([card_to_swap], pile_type, "other_" + pile_type)
			yield(self, "UI_update_completed")
			#remove this card as a child and disconnect movement signal
			if card_to_swap.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
				card_to_swap.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
			if is_a_parent_of(card_to_swap):
				remove_child(card_to_swap)
			#add this card as a child of the other player and connect movement signal
			other_player.add_child(card_to_swap)
			card_to_swap.get_node("MovementHandler").connect("movement_completed", other_player, "on_card_movement_completed")
	if other_player_pile.size() > 0:
		for card_to_swap in other_player_pile:
			other_player.move_cards_to([card_to_swap], pile_type, "other_" + pile_type)
			yield(other_player, "UI_update_completed")
			#remove this card as a child and disconnect movement signal
			if card_to_swap.get_node("MovementHandler").is_connected("movement_completed", other_player, "on_card_movement_completed"):
				card_to_swap.get_node("MovementHandler").disconnect("movement_completed", other_player, "on_card_movement_completed")
			if other_player.is_a_parent_of(card_to_swap):
				other_player.remove_child(card_to_swap)
			#add this card as a child of the other player and connect movement signal
			add_child(card_to_swap)
			card_to_swap.get_node("MovementHandler").connect("movement_completed", self, "on_card_movement_completed")
	emit_signal("swap_completed")

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
	elif id == "074": #blank card
		#When played, choose the suit and value for the blank card to take
		var choices = []
		choices.append_array(["001", "002", "003", "004", "005", "006", "007", "008", "009", "010"])
		choices.append_array(["014", "015", "016", "017", "018", "019", "020", "021", "022", "023"])
		choices.append_array(["027", "028", "029", "030", "031", "032", "033", "034", "035", "036"])
		choices.append_array(["040", "041", "042", "043", "044", "045", "046", "047", "048", "049"])
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choices)
	elif id == "076": #Get Well Soon card
		get_parent().get_node("Player").heal(10, card.position)
	elif id == "077": #+2 Card
		get_parent().get_node("Opponent").draw_top_card()
		yield(get_parent().get_node("Opponent"), "UI_update_completed")
		get_parent().get_node("Opponent").draw_top_card()
		yield(get_parent().get_node("Opponent"), "UI_update_completed")
	elif id == "078": #Reverse Card
		swap_piles("play_pile", play_pile, get_parent().get_node("Opponent").play_pile)
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
		#- reveal the next X cards in your draw pile in order
		var i = 0
		var choice_array = []
		while draw_pile[i] != null and i < 3: #need to protect against checking a draw pile that has less than 3 items
			choice_array.append(draw_pile[i].card_id)
			i += 1
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "125": #III The Empress
		# locks an 11 of hearts to players play pile
		var eleven_of_hearts = instance_new_card("062")
		add_child(eleven_of_hearts)
		add_cards_to_draw_pile([eleven_of_hearts])
		move_cards_to([eleven_of_hearts], "draw_pile", "play_pile")
		eleven_of_hearts.score_before_played = score
		eleven_of_hearts.lock_card()
	elif id == "126": #IV The Emperer
		#score over 21 this turn will instead be taken as damage to both players
		blackjack_cap_type = "damage_both"
	elif id == "127": #V The Hierophant
		#score over 21 this turn will instead heal both players
		blackjack_cap_type = "heal_both"
	elif id == "128": #VI The Lovers
		#choose from the following to add to draw pile: valentines card, ace of hearts, another 6 The Lovers
		var choice_array = ["146", "040" ,"128"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "129": #VII The Chariot
		chariot_effect_active = true
	elif id == "130": #VIII Justice
		#replaces all of your jacks with jack of all trades. Adds a jack of all trades to draw pile
		#get all the jacks in all piles in an array
		var jacks = []
		var all_piles = []
		all_piles.append_array(draw_pile)
		all_piles.append_array(play_pile)
		all_piles.append_array(discard_pile)
		for card in all_piles:
			if card.card_id == "011" or card.card_id == "024" or card.card_id == "037" or card.card_id == "050":
				jacks.append(card)
		#set jacks to be jack of all trades
		for jack in jacks: 
			jack.set_card_id("075")
		#add a new jack of all trades to draw pile
		var new_jack = instance_new_card("075")
		add_cards_to_draw_pile([new_jack])
	elif id == "131": #IX The Hermit
		#add X decaying healing per turn, add 1 to X
		if card.x_value == 0:
			card.set_card_x_value(1)
		decaying_healing += card.x_value
		card.set_card_x_value(card.x_value + 1)
	elif id == "132": #X Wheel of Fortune
		var wheel = load("res://WheelOfFortune.tscn").instance()
		wheel.position = Vector2(57/2, 89/2)
		card.add_child(wheel)
		yield(wheel, "spin_completed")
		if wheel.wheel_frame < 5: # add chips
			add_chips(5, card.position)
		elif wheel.wheel_frame < 10: # burn a card in discard pile
			if discard_pile.size() > 0:
				get_node("ChoiceController")._on_Player_card_choice_to_make(card, discard_pile)
		elif wheel.wheel_frame < 15: # heal
			heal(5, card.position)
		elif wheel.wheel_frame < 20: # add a random reward card to draw pile
			var choice_array = []
			for n in 5:
				choice_array.append(CardList.get_random_reward_card_id())
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "133": #XI Strength
		#opponent cannot hit again this round
		get_parent().get_node("Opponent").rounds_to_skip += 1
	elif id == "134": #XII The Hanged Man
		# burn a card in discard pile
		if discard_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, discard_pile)
	elif id == "135": #XIII Death
		var all_piles = []
		all_piles.append_array(draw_pile)
		all_piles.append_array(play_pile)
		all_piles.append_array(discard_pile)
		all_piles.erase(card) #can't burn the death card
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, all_piles)
	elif id == "136": #XIV Temperence
		#Adds X chips. Multiply X by 2
		if card.x_value == 0:
			card.set_card_x_value(1)
		add_chips(card.x_value, card.position)
		card.set_card_x_value(card.x_value * 2)
	elif id == "137": #XV The Devil
		#if you get blackjack with this card in play pile it multiplies damage dealt by 6. if you do not get blackjack deals 6 damage to player
		devil_effect_active = true
	elif id == "138": #XVI The Tower
		#locks the first card in play for both players
		if play_pile.size() > 0:
			play_pile[0].lock_card()
		var opponent_play_pile = get_parent().get_node("Opponent").play_pile
		if opponent_play_pile.size() > 0:
			opponent_play_pile[0].lock_card()
	elif id == "139": #XVII The Star
		#heal self by 17, do double damage this round win
		heal(17, card.position)
		star_effect_active = true
	elif id == "140": #XVIII The Moon
		#Locks. shrouds cards opponent has played. You deal 3x damage
		card.lock_card()
		moon_damage_effect_active = true
		get_parent().get_node("Opponent").moon_shroud_effect_active = true
	elif id == "141": #XIX The Sun
		#choose a card in your draw pile to put on top of draw pile.
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, draw_pile)
	elif id == "142": #XX Judgment
		#take no damage from the next opponent blackjack
		judgment_shield_active = true
	elif id == "143": #XXI The World
		card.lock_card()
	elif id == "144": #0 The Fool
		swap_piles("play_pile", play_pile, get_parent().get_node("Opponent").play_pile)
		swap_piles("discard_pile", discard_pile, get_parent().get_node("Opponent").discard_pile)
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
		new_card.connect("card_clicked", self, "_on_SleeveCard_clicked", [new_card])
		
		move_cards_to([new_card], "play_pile", "sleeve_pile")
	elif id == "146": #valentines card
		heal(14, card.position)
		get_parent().get_node("Opponent").heal(14, card.position)
	elif id == "147": #kanban card
		#Select a card from draw pile and place this card into the draw pile above it
		if draw_pile.size() > 1:
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, draw_pile)
	elif id == "148": #Dis-card
		#Select a card that is in play and discard it
		var both_play_piles = []
		both_play_piles.append_array(play_pile)
		both_play_piles.append_array(get_parent().get_node("Opponent").play_pile)
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, both_play_piles)
	elif id == "149": #Loyalty card
		#The tenth time this card is played it sets the players score to 21
		#remove current stamps
		for child in card.get_children():
			if child.is_in_group("stamps"):
				card.remove_child(child)
		#increment x value
		card.set_card_x_value(card.x_value + 1)
		if card.x_value <= 9:
			#add new stamps
			for i in card.x_value:
				var stamp_sprite = Sprite.new()
				card.add_child(stamp_sprite)
				stamp_sprite.texture = load("res://assets/art/suit_icons_all_11_11.png")
				stamp_sprite.hframes = 26
				stamp_sprite.frame = 11
				var x = i % 3 #row
				var y = floor(i / 3) #column
				stamp_sprite.position = Vector2(x * 17 + 12, y * 17 + 13)
				stamp_sprite.add_to_group("stamps")
		elif card.x_value == 10:
			#reset x value 
			card.set_card_x_value(0)
			#and set player score to 21 by changing the value of this card
			card.set_card_value(21 - score)
	elif id == "150": #Four mana seven seven
		card.lock_card()

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
	elif id == "074": #blank card
		#When played, choose the suit and value for the blank card to take
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + str(origin_card.get_card_value()) + ")")
		origin_card.set_card_suit(CardList.card_dictionary[choice_made].suit)
	elif id == "079" || id == "090" || id == "101" || id == "112" : #negative aces
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + str(origin_card.get_card_value()) + ")")
	elif id == "124": #II The High Priestess
		pass #literally do nothing since all we are doing is showing the order of the next few cards in draw pile and the choice UI is just a convenient way to do that
	elif id == "128": #VI The Lovers
		var new_card = instance_new_card(choice_made)
		add_cards_to_draw_pile([new_card])
	elif id == "132": #X Wheel of Fortune
		if origin_card.get_node("WheelOfFortune").wheel_frame < 10:
			choice_made.start_burn_animation()
			#wait for burn animation
			yield(choice_made, "burn_complete")
			#remove card burnt as children
			discard_pile.erase(choice_made)
			cards_currently_moving.erase(choice_made)
			if choice_made.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
				choice_made.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
			remove_child(choice_made)
		elif origin_card.get_node("WheelOfFortune").wheel_frame < 20:
			var new_card = instance_new_card(choice_made)
			add_cards_to_draw_pile([new_card])
	elif id == "134": #XII The Hanged Man
		choice_made.start_burn_animation()
		#wait for burn animation
		yield(choice_made, "burn_complete")
		#remove card burnt as children
		discard_pile.erase(choice_made)
		cards_currently_moving.erase(choice_made)
		if choice_made.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
			choice_made.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
		remove_child(choice_made)
	elif id == "135": #XIII Death
		#choice_made might not yet be a child since it could be in the draw pile
		if choice_made.is_inside_tree(): #can't play burn animation if it's not yet a child
			choice_made.start_burn_animation()
			#wait for burn animation
			yield(choice_made, "burn_complete")
		#remove card burnt as children
		if draw_pile.has(choice_made):
			draw_pile.erase(choice_made)
		if play_pile.has(choice_made):
			play_pile.erase(choice_made)
		if discard_pile.has(choice_made):
			discard_pile.erase(choice_made)
		cards_currently_moving.erase(choice_made)
		if choice_made.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
			choice_made.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
		if choice_made.is_inside_tree(): #if its a child remove it
			remove_child(choice_made)
		#and now remove it from deck
		get_parent().get_parent().player_deck.erase(choice_made.card_id)
	elif id == "141": #XIX The Sun
		draw_pile.erase(choice_made)
		add_card_to_draw_pile_at_position(choice_made, 0)
	elif id == "143": #XXI The World
		var new_tarot_card = instance_new_card(choice_made)
		add_card_to_draw_pile_at_position(new_tarot_card, 0)
	elif id == "147": #kanban card
		#Select a card from draw pile and place this card into the draw pile above it
		add_card_to_draw_pile_at_position(origin_card, choice_index)
		play_pile.erase(origin_card)
		remove_child(origin_card)
	elif id == "148": #Dis-card
		#Select a card that is in play and discard it
		if self.is_a_parent_of(choice_made): #it is the players card that was chosen
			discard_cards([choice_made])
		else: #it is the opponents card
			get_parent().get_node("Opponent").discard_cards([choice_made])
	
	current_card_effect_id = null

func _on_SleeveCard_clicked(card):
	move_cards_to([card], "sleeve_pile", "play_pile")
	play_card_draw_effect(card, card.card_id)

func play_end_of_shuffle_effect(card, id):
	if self.name == "Opponent": #currently this means opponents are unable to use special cards
		return
	
	current_card_effect_id = id
	
	if id == "143": #XXI The World
		var choice_array = []
		for n in 3:
			var tarot_id = CardList.get_random_tarot_card_id()
			while choice_array.has(tarot_id) or tarot_id == "143": #don't allow it to pick an id already in list or the world card
				tarot_id = CardList.get_random_tarot_card_id()
			choice_array.append(tarot_id)
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)

func play_card_start_of_turn_effect(card, id):
	if self.name == "Opponent": #currently this means opponents are unable to use special cards
		return

	current_card_effect_id = id

	if id == "150": #Four mana seven seven
		#At the start of your turn adds a 4 of clubs to your side and a 7 of clubs to your opponent
		var four_of_clubs = instance_new_card("017")
		add_child(four_of_clubs)
		add_cards_to_draw_pile([four_of_clubs])
		move_cards_to([four_of_clubs], "draw_pile", "play_pile")
		yield(self, "UI_update_completed")
		
		var opponent = get_parent().get_node("Opponent")
		var seven_of_clubs = opponent.instance_new_card("020")
		opponent.add_child(seven_of_clubs)
		opponent.add_cards_to_draw_pile([seven_of_clubs])
		opponent.move_cards_to([seven_of_clubs], "draw_pile", "play_pile")
		yield(opponent, "UI_update_completed")

#func play_card_end_of_turn_effect(card, id):
#	if self.name == "Opponent": #currently this means opponents are unable to use special cards
#		return
#
#	current_card_effect_id = id
#
#	if id == "":
#		pass
#
func play_card_discard_effect(card, id):
	if self.name == "Opponent": #currently this means opponents are unable to use special cards
		return

	current_card_effect_id = id

	if id == "001" || id == "014" || id == "027" || id == "040" : #aces
		#reset card to how it was before played
		card.set_card_value(CardList.card_dictionary[id].value)
		card.set_card_art(id)
		card.set_card_name(CardList.card_dictionary[id].name)
		card.set_card_suit(CardList.card_dictionary[id].suit)
	elif id == "074": #blank card
		#reset card to how it was before played
		card.set_card_value(CardList.card_dictionary[id].value)
		card.set_card_art(id)
		card.set_card_name(CardList.card_dictionary[id].name)
		card.set_card_suit(CardList.card_dictionary[id].suit)
	elif id == "149": #Loyalty card
		#reset the value of the card since it should only set score to 21 for one round
		card.set_card_value(CardList.card_dictionary[id].value)
		
