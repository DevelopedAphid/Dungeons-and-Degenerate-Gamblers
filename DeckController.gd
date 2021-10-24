extends Node

signal card_effect_ended

var deck = []
var draw_pile = []
var play_pile = []
var discard_pile = []
var score = 0
var hitpoints = 100

var Card = preload("res://Card.tscn")

func ready():
	pass

func add_card_to_deck(card_id):
	#add a defined card to the deck
	var new_card = Card.instance()
	new_card.set_card_id(card_id)
	deck.append(new_card)

func build_draw_pile():
	#put deck list into draw pile
	for cards in deck.size():
		draw_pile.append(deck[cards])
	
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
	
	if score > 20:
		pass
	else:
		#move top draw pile card to top of play pile
		var top_card = draw_pile[0]
		if top_card.has_special_effect():
			play_card_effect(top_card, top_card.get_card_id())
		
		draw_pile.pop_front()
		play_pile.append(top_card)
	
	update_UI()

func shuffle_discard_pile_into_draw_pile():
	#put everything in discard pile into draw pile
	for cards in discard_pile.size():
		draw_pile.append(discard_pile[cards])
	for cards in discard_pile.size():
		discard_pile.pop_front()

func discard_played_cards():
	for cards in play_pile.size():
		discard_pile.append(play_pile[cards])
	for cards in play_pile.size():
		play_pile.pop_front()
	score = 0
	update_UI()

#func add_card_to_draw_pile(card, position):
#	#add a defined card to the draw pile at a defined position
#	pass

func update_UI():
	get_node("DrawPileLabel").text = "Cards Remaining:" + str(draw_pile.size())
	update_UI_pile_label(get_node("PlayPileLabel"), play_pile)
	update_UI_pile_label(get_node("DiscardPileLabel"), discard_pile)
	get_node("ScoreLabel").text = str(score)
	get_node("HitpointsLabel").text = str(hitpoints)

func update_UI_pile_label(label, pile):
	label.text = ""
	for cards in pile:
		label.text = label.text + cards.get_card_name() + "\n"

func _on_Card_choice_to_make(choice_array, card):
	emit_signal("card_choice_to_make", choice_array, card)

func play_card_effect(card, id):
	if self.name == "Opponent": #TODO: not good, need to sort later
		return
	
	if id == "001" || id == "014" || id == "027" || id == "040" : #aces
		var choice_array = [id, "056"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(choice_array)
		var choice_made = yield(get_node("ChoiceController"), "choice_made")
		card.set_card_value(CardList.card_dictionary[choice_array[choice_made]].value)
		card.set_card_name(CardList.card_dictionary[id].name + " (" + str(card.get_card_value()) + ")")
	elif id == "069": #Joker
		if discard_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(discard_pile)
			var choice_made = yield(get_node("ChoiceController"), "choice_made")
			card.set_card_value(discard_pile[choice_made].get_card_value())
			card.set_card_name("Joker (" + discard_pile[choice_made].get_card_name() + ")")
	elif id == "070": #birthday card
		card.set_card_value(card.get_card_value() + 1)
		card.set_card_name(CardList.card_dictionary["070"].name + " (" + str(card.get_card_value()) + ")")
	elif id == "071": #magic trick card
		var choice_array = ["051", "020"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(choice_array)
		var choice_made = yield(get_node("ChoiceController"), "choice_made")
		card.set_card_value(CardList.card_dictionary[choice_array[choice_made]].value)
		card.set_card_name(CardList.card_dictionary[id].name + " (" + CardList.card_dictionary[choice_array[choice_made]].name + ")")
	elif id == "072": #Red Joker
		if draw_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(draw_pile)
			var choice_made = yield(get_node("ChoiceController"), "choice_made")
			card.set_card_value(draw_pile[choice_made].get_card_value())
			card.set_card_name("Red Joker (" + draw_pile[choice_made].get_card_name() + ")")
	
	emit_signal("card_effect_ended")

