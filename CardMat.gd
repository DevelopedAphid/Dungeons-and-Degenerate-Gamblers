extends Node2D

var deck_contents = []
var cards_in_play = []
var score = 0
var rng

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	reset_game()

func reset_game():
	deck_contents = []
	cards_in_play = []
	score = 0
	
	get_node("DeckLabel").text = ""
	get_node("InPlayLabel").text = ""
	get_node("HitButton").text = "0"
	
	for n in 52:
		deck_contents.append(n+1)

func _on_ShuffleButton_pressed():
	reset_game()
	
	#shuffle the deck
	for i in deck_contents.size():
		var random = i + rng.randi_range(0,51 - i)
		var temp = deck_contents[random]
		deck_contents[random] = deck_contents[i]
		deck_contents[i] = temp
	
	update_deck_contents_list()


func _on_HitButton_pressed():
	if score > 20:
		return
	
	#move top card from deck to be bottom of in play list
	var top_card = deck_contents[0]
	cards_in_play.append(top_card)
	deck_contents.pop_front()
	
	update_deck_contents_list()
	update_cards_in_play_list()
	
	score = score + get_card_value(top_card)
	
	var hit_button = get_node("HitButton")
	hit_button.text = str(score)
	
	if score > 21:
		hit_button.text = "BUST"

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
	
