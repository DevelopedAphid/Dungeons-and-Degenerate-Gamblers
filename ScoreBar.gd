extends Node2D

var icon_sprite_path = preload("res://assets/art/suit_icons_9_9.png")

var current_score = 0

func update_score(score):
	#remove current icons
	var sprite_array = []
	for child in get_children():
		if child.is_in_group("suit_icons"):
			sprite_array.append(child)
	for child in sprite_array:
		child.queue_free()
	
	#add new icons
	if score <= 21:
		for i in score:
			var new_sprite = Sprite.new()
			new_sprite.texture = icon_sprite_path
			new_sprite.hframes = 4
			new_sprite.add_to_group("suit_icons")
			add_child(new_sprite)
			new_sprite.position = Vector2(10 + i * 12, 9.5)
