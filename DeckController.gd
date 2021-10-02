extends Node

signal turn_ended(action_taken)

var deck = []
var draw_pile = []
var play_pile = []
var discard_pile = []
var score = 0
var hitpoints = 100

func ready():
	pass

func add_card_to_deck(card_id):
	#add a defined card to the deck
	deck.append(card_id)

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
		end_turn("stay")
	else:
		#move top draw pile card to top of play pile
		var top_card = draw_pile[0]
		play_pile.append(top_card)
		draw_pile.pop_front()
	
		score = score + get_card_number_value(top_card)
		end_turn("hit")
	
	update_UI()

func end_turn(action):
	emit_signal("turn_ended", action)

func get_card_number_value(card) -> int:
	var card_value
	if card < 10:
		card_value = CardList.card_dictionary.get("00" + str(card)).value
	else:
		card_value = CardList.card_dictionary.get("0" + str(card)).value
	if typeof(card_value) == 4: #if value is a string
		if card_value == "J" || card_value == "Q" || card_value == "K":
			card_value = 10
	return card_value

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
	get_node("DrawPileLabel").text = str(draw_pile)
	get_node("PlayPileLabel").text = str(play_pile)
	get_node("DiscardPileLabel").text = str(discard_pile)
	get_node("ScoreLabel").text = str(score)
	get_node("HitpointsLabel").text = str(hitpoints)
