extends Node2D

var card_id
var card_name
var card_suit
var card_value
var card_sprite

func _ready():
	pass

func set_card_id(id):
	card_id = id
	card_name = CardList[card_id].name
	card_suit = CardList[card_id].suit
	card_value = CardList[card_id].value

func get_card_id() -> String:
	return card_id

func set_card_value(value):
	card_value = value

func get_card_value() -> int:
	return card_value

func play_card():
	pass
