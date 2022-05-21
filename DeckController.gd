extends Node

signal UI_update_completed

var UI_currently_updating = false

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
		deck[cards].position = get_node("DeckDisplay").position
	
	shuffle_draw_pile()
	
	update_UI()

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
	#if not yet busted, draw the top card and enact it's effect
	
	#check draw_pile has at least 1 card first
	if draw_pile.size() == 0:
		shuffle_discard_pile_into_draw_pile()
	
	#move top draw pile card to top of play pile
	var top_card = draw_pile[0]
	
	top_card.score_before_played = score
	
	draw_pile.pop_front()
	play_pile.append(top_card)
	
	#if first time drawn then add it as a child so we can display it
	if top_card.get_parent() == null:
		add_child(top_card)
	
	update_UI()
	
	yield(self, "UI_update_completed")
	
	if top_card.has_special_effect():
		play_card_effect(top_card, top_card.get_card_id())
	
	update_UI()

func shuffle_discard_pile_into_draw_pile():
	#put everything in discard pile into draw pile
	for card in discard_pile.size():
		draw_pile.append(discard_pile[card])
	for card in discard_pile:
		card.set_card_art(card.get_card_id()) #reset card art to default
		card.set_card_suit(CardList.card_dictionary[card.get_card_id()].suit)
		remove_child(card)
	for cards in discard_pile.size():
		discard_pile.pop_front()
	shuffle_draw_pile()
	update_UI()

func discard_played_cards():
	for card in play_pile:
		if card.card_does_burn:
			remove_child(card) #do not discard
		else: #card does not burn, so should be discarded
			discard_pile.append(card)
	for cards in play_pile.size():
		play_pile.pop_front()
	score = 0
	update_UI()

#func add_card_to_draw_pile(card, position):
#	#add a defined card to the draw pile at a defined position
#	pass

func heal(heal_amount: int):
	if hitpoints + heal_amount > max_hitpoints:
		hitpoints = max_hitpoints
	else: 
		hitpoints += heal_amount

func update_UI():
	UI_currently_updating = true
	#todo: make this way less ugly - use signals and call from game controller instead of deck controller
	#or... make the battle sprites and health labels children of the player/opponent nodes so we can just call them as children like everything else
	if name == "Player":
		get_parent().get_node("BattleScene/PlayerHealthLabel").text = str(hitpoints) + "/" + str(max_hitpoints)
	if name == "Opponent":
		get_parent().get_node("BattleScene/OpponentHealthLabel").text = str(hitpoints) + "/" + str(max_hitpoints)
	
	$ScoreBar.update_score(score)
	
	if name == "Player":
		get_node("ChipCounter").change_chip_number(chips)
	
	$DeckDisplay.change_deck_size(draw_pile.size())
	
	if name == "Opponent":
		play_pile_card_spacing = -14
		discard_pile_card_spacing = -4
	
	var play_pile_count = 0
	var discard_pile_count = 0
	for card in play_pile:
		card.get_node("MovementHandler").move_card_to(play_pile_pos + Vector2(play_pile_card_spacing * play_pile_count, 0))
		play_pile_count += 1
	
	for card in discard_pile:
		card.get_node("MovementHandler").move_card_to(discard_pile_pos + Vector2((discard_pile_count - 1) * discard_pile_card_spacing, 0))
		discard_pile_count += 1
	
	if play_pile.size() == 0 and discard_pile.size() == 0:
		UI_currently_updating = false

func on_card_movement_completed():
	UI_currently_updating = false
	for card in play_pile:
		if card.get_node("MovementHandler").is_moving:
			UI_currently_updating = true
	for card in discard_pile:
		if card.get_node("MovementHandler").is_moving:
			UI_currently_updating = true
	if UI_currently_updating == false:
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
		#temporary play pile references
		var player_play_pile = play_pile
		var opponent_play_pile = get_parent().get_node("Opponent").play_pile
		#remove children from parent
		for card in play_pile:
			remove_child(card)
		for card in get_parent().get_node("Opponent").play_pile:
			get_parent().get_node("Opponent").remove_child(card)
		#swap the piles
		play_pile = opponent_play_pile
		get_parent().get_node("Opponent").play_pile = player_play_pile
		#have to reparent to make sure children behaviour works as normal
		for card in play_pile:
			add_child(card)
		for card in get_parent().get_node("Opponent").play_pile:
			get_parent().get_node("Opponent").add_child(card)
	
	update_UI()


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
	update_UI()
