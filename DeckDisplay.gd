extends Node2D

var card_sprite = preload("res://assets/art/card_sprite_sheet.png")
var card_pos = Vector2(0, 0)
var card_spacing = Vector2(2, 0)

func change_deck_size(deck_size: float):
	if get_parent():
		if get_parent().name == "Player":
			card_spacing = Vector2(2, 0)
		elif get_parent().name == "Opponent":
			card_spacing = Vector2(-2, 0)
	
	for child in get_children():
		child.queue_free()
	if deck_size == 0:
		pass
	elif deck_size == 1:
		add_cards(1)
	elif deck_size > 12:
		add_cards(ceil(12/3) + 1)
	else:
		add_cards(ceil(deck_size/3) + 1)

func add_cards(number):
	for i in number:
		var deck_sprite = Sprite.new()
		deck_sprite.centered = false
		deck_sprite.texture = card_sprite
		deck_sprite.hframes = 13
		deck_sprite.vframes = 6
		deck_sprite.frame_coords = Vector2(7,5)
		deck_sprite.position = card_pos + card_spacing * i
		
		add_child(deck_sprite)
