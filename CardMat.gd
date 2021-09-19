extends Node2D

var deck_contents = []
var cards_in_play = []
var cards_discarded = []
var score = 0
var rng
var starting_suit

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	reset_game()

func reset_game():
	starting_suit = PlayerSettings.chosen_suit
	
	deck_contents = []
	cards_in_play = []
	cards_discarded = []
	score = 0
	
	get_node("DeckLabel").text = ""
	get_node("InPlayLabel").text = ""
	get_node("DiscardLabel").text = ""
	get_node("HitButton").text = "0"
	
	var first_card_index
	if starting_suit == "spades":
		first_card_index = 1
	elif starting_suit == "clubs":
		first_card_index = 14
	elif starting_suit == "diamonds":
		first_card_index = 27
	elif starting_suit == "hearts":
		first_card_index = 40
	
	for n in 13: #all cards of one suit
		deck_contents.append(n + first_card_index)

func _on_ShuffleButton_pressed():
	reset_game()
	shuffle_deck()

func shuffle_deck():
	#shuffle the deck
	for i in deck_contents.size():
		var random = i + rng.randi_range(0, deck_contents.size() - 1 - i)
		var temp = deck_contents[random]
		deck_contents[random] = deck_contents[i]
		deck_contents[i] = temp
	
	update_deck_contents_list()

func _on_HitButton_pressed():
	#if no cards remaining
	if deck_contents.size() == 0: 
		shuffle_discard_into_deck()
	
	#move top card from deck to be bottom of in play list
	var top_card = deck_contents[0]
	cards_in_play.append(top_card)
	deck_contents.pop_front()
		
	score = score + get_card_value(top_card)
	
	var hit_button = get_node("HitButton")
	hit_button.text = str(score)
	
	if score > 20:
		if score > 21:
			hit_button.text = "BUST"
		
		for cards in cards_in_play.size():
			cards_discarded.append(cards_in_play[cards])
		for cards in cards_in_play.size():
			cards_in_play.pop_front()
		score = 0
	
	update_deck_contents_list()
	update_cards_in_play_list()
	update_cards_discarded_list()

func update_deck_contents_list():
	var deck_label = get_node("DeckLabel")
	deck_label.text = ""
	
	for card in deck_contents:
		if card < 10:
			deck_label.text = deck_label.text + "\n" + CardList.card_dictionary.get("00" + str(card)).name
		else:
			deck_label.text = deck_label.text + "\n" + CardList.card_dictionary.get("0" + str(card)).name

func update_cards_in_play_list():
	var in_play_label = get_node("InPlayLabel")
	in_play_label.text = ""
	
	for card in cards_in_play:
		if card < 10:
			in_play_label.text = in_play_label.text + "\n" + CardList.card_dictionary.get("00" + str(card)).name
		else:
			in_play_label.text = in_play_label.text + "\n" + CardList.card_dictionary.get("0" + str(card)).name

func update_cards_discarded_list():
	var discard_label = get_node("DiscardLabel")
	discard_label.text = ""
	
	for card in cards_discarded:
		if card < 10:
			discard_label.text = discard_label.text + "\n" + CardList.card_dictionary.get("00" + str(card)).name
		else:
			discard_label.text = discard_label.text + "\n" + CardList.card_dictionary.get("0" + str(card)).name

func get_card_value(card) -> int:
	var card_value
	if card < 10:
		card_value = CardList.card_dictionary.get("00" + str(card)).value
	else:
		card_value = CardList.card_dictionary.get("0" + str(card)).value
	if typeof(card_value) == 4: #if value is a string
		if card_value == "J" || card_value == "Q" || card_value == "K":
			card_value = 10
	return card_value

func shuffle_discard_into_deck():
	for cards in cards_discarded.size():
		deck_contents.append(cards_discarded[cards])
	for cards in cards_discarded.size():
		cards_discarded.pop_front()
	
	shuffle_deck()
