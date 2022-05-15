extends Node2D

signal card_clicked(card)
signal card_hover_started(card)
signal card_hover_ended(card)

export var card_id = "073" #default to card back
var card_name = ""
var card_suit = ""
var card_value = 0
var card_sprite = ""
var card_description = ""
var card_does_burn = false

var score_before_played
var is_focused

func _ready():
	set_card_id(card_id)
	highlight_card(false)

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
	if CardList.card_dictionary[card_id].has("description"):
		card_description = CardList.card_dictionary[card_id].description
	if CardList.card_dictionary[card_id].has("burns"):
		card_does_burn = CardList.card_dictionary[card_id].burns
	
	set_card_art(card_id)

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

func set_card_suit(suit):
	card_suit = suit

func get_card_suit() -> String:
	return card_suit

func set_card_art(id):
	#set card art according to position on sprite sheet
	var card_sprite_index = float(id) - 1
	var row = floor(card_sprite_index/13)
	var col = fmod(card_sprite_index, 13)
	
	$CardArtSprite.frame_coords.x = col
	$CardArtSprite.frame_coords.y = row

func has_special_effect() -> bool:
	return CardList.card_dictionary[card_id].effect

func sprite_clicked():
	if is_focused:
		emit_signal("card_clicked")

func highlight_card(to_highlight: bool):
	$HighlightSprite.visible = to_highlight
	is_focused = to_highlight

func _on_HoverArea_mouse_entered():
	emit_signal("card_hover_started", self)

func _on_HoverArea_mouse_exited():
	emit_signal("card_hover_ended", self)
