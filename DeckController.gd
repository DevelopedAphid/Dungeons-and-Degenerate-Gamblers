extends Node

signal UI_update_completed

var deck = []
var draw_pile = []
var play_pile = []
var discard_pile = []
var burn_pile = []
var score = 0
var hitpoints = 100
var max_hitpoints
var bleedpoints = 0
var current_card_effect_id
var chips = 0

#screen positions and spacing
onready var play_pile_pos = $PlayPilePosition.position
onready var discard_pile_pos = $DiscardPilePosition.position
var play_pile_card_spacing = 14
var discard_pile_card_spacing = 4

var cards_currently_moving = []

var Card = preload("res://Card.tscn")

func _ready():
	if name == "Player":
		hitpoints = PlayerSettings.player_hitpoints
		max_hitpoints = PlayerSettings.player_max_hitpoints
	elif name == "Opponent":
		hitpoints = PlayerSettings.opponent_health_points
		max_hitpoints = hitpoints

func add_card_to_deck(card_id):
	#add a defined card to the deck
	var new_card = Card.instance()
	new_card.call_deferred("set_card_id", card_id)
	deck.append(new_card)
	
	new_card.connect("card_hover_started", get_parent().get_node("HoverPanel"), "_on_Card_hover_started")
	new_card.connect("card_hover_ended", get_parent().get_node("HoverPanel"), "_on_Card_hover_ended")
	new_card.get_node("MovementHandler").connect("movement_completed", self, "on_card_movement_completed")

func build_draw_pile():
	#put deck list into draw pile
	for cards in deck.size():
		draw_pile.append(deck[cards])
		deck[cards].position = $DeckDisplay.position
	
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
	#draw the top card and enact it's effect\
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
		play_card_effect(top_card, top_card.get_card_id())

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
		else: #card does not burn, so should be discarded
			cards_to_discard.append(card)
	for card in cards_to_burn:
		cards_currently_moving.erase(card)
		if card.get_node("MovementHandler").is_connected("movement_completed", self, "on_card_movement_completed"):
			card.get_node("MovementHandler").disconnect("movement_completed", self, "on_card_movement_completed")
		call_deferred("remove_child", card)
	
	move_cards_to(cards_to_discard, "play_pile", "discard_pile")
	
	#wait for cards to finish moving
	yield(self, "UI_update_completed")
	
	#set score to 0 since round is over
	score = 0

#func add_card_to_draw_pile(card, position):
#	#add a defined card to the draw pile at a defined position
#	pass

func heal(heal_amount: int):
	if hitpoints + heal_amount > max_hitpoints:
		hitpoints = max_hitpoints
	else: 
		hitpoints += heal_amount

func move_cards_to(cards, from_pile, to_pile):
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
		#remove cards from from_pile
		match from_pile:
			"play_pile":
				play_pile.erase(card)
			"discard_pile":
				discard_pile.erase(card)
			"draw_pile":
				draw_pile.erase(card)

func on_card_movement_completed(card):
	cards_currently_moving.erase(card)
	if cards_currently_moving.size() == 0:
		emit_signal("UI_update_completed")

func _on_Card_choice_to_make(choice_array, card):
	emit_signal("card_choice_to_make", choice_array, card)

func play_card_effect(card, id):
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
		candle.frame = round(rand_range(1,5)) #choose a random candle colour
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
		get_parent().get_node("Player").heal(10)
		get_parent().get_node("Opponent").heal(10)
	elif id == "077": #+2 Card
		get_parent().get_node("Opponent").draw_top_card()
		get_parent().get_node("Opponent").draw_top_card()
	elif id == "078": #Reverse Card
		var opponent = get_parent().get_node("Opponent")
		var player_play_pile = []
		for card_to_swap in play_pile:
			player_play_pile.append(card_to_swap)
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
		call_deferred("play_card_effect", origin_card, choice_made.get_card_id())
	current_card_effect_id = null
