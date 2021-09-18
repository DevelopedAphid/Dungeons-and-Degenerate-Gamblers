extends Node2D

var deck_contents = []
var rng

func _ready():
	for n in 52:
		deck_contents.append(n+1)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _on_ShuffleButton_pressed():
	var deck_label = get_node("DeckLabel")
	
	deck_label.text = ""
	
	for i in deck_contents.size():
		var random = i + rng.randi_range(0,51 - i)
		var temp = deck_contents[random]
		deck_contents[random] = deck_contents[i]
		deck_contents[i] = temp
	
	for card in deck_contents:
		if card < 10:
			deck_label.text = deck_label.text + "\n" + CardList.card_dictionary.get("00" + str(card)).name
		else:
			deck_label.text = deck_label.text + "\n" + CardList.card_dictionary.get("0" + str(card)).name
