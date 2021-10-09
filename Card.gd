extends Node2D

var card_id
var card_name
var card_suit
var card_value
var card_sprite

func set_card_id(id):
	if typeof(id) == 4: #if already a string
		card_id = id
	elif id < 10:
		card_id = "00" + str(id)
	elif id < 100:
		card_id = "0" + str(id)
	else: 
		card_id = str(id)
	card_name = CardList.card_dictionary[card_id].name
	card_suit = CardList.card_dictionary[card_id].suit
	card_value = CardList.card_dictionary[card_id].value

func get_card_id() -> String:
	return card_id

func set_card_value(value):
	card_value = value

func get_card_value() -> int:
	var value = card_value
	if typeof(value) == 4: #if value is a string - and therefore a face or special card
		if value == "J" || value == "Q" || value == "K": #face cards
			value = 10
		else:
			value = 0
	return value

func set_card_name(name):
	card_name = name

func get_card_name() -> String:
	return card_name

func play_card_effect():
	if card_id == "069": #Joker
		pass
	elif card_id == "070": #Birthday Card
		card_value = card_value + 1
		set_card_name(CardList.card_dictionary["070"].name + " (" + str(card_value) + ")")
	else: 
		pass

func has_special_effect() -> bool:
	return CardList.card_dictionary[card_id].effect
