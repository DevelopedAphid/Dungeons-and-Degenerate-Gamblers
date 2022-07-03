extends Node2D

var icon_sprite_path = preload("res://assets/art/suit_icons_9_9.png")
var inverted_icon_sprite_path = preload("res://assets/art/suit_icons_inverted_9_9.png")
var icon_highlight_path = preload("res://assets/art/suit_icon_highlights_9_9.png")

var current_score = 0

onready var font = Fonts.font_pixel_5_9

func _ready():
	$ScoreLabel.add_font_override("font", font)
	$ExcessLabel.add_font_override("font", font)

func update_score():
	#remove current icons
	var sprite_array = []
	for child in get_children():
		if child.is_in_group("suit_icons"):
			sprite_array.append(child)
	for child in sprite_array:
		child.queue_free()
	
	var score = 0
	for card in get_parent().play_pile:
		score = score + card.get_card_value()
	get_parent().score = score
	
	$ScoreLabel.text = str(score)
	$ExcessLabel.visible = false
	if score > 21:
		if get_parent().blackjack_cap_type != "none":
			$ScoreLabel.text = str(21)
			$ExcessLabel.text = str(score - 21)
			$ExcessLabel.visible = true
	
	if $ScoreLabel.text.length() == 1:
		$ScoreLabel.rect_position = Vector2(6, -25)
	else: #doesn't handle 3 digit score but not sure if that matters
		$ScoreLabel.rect_position = Vector2(3, -25)
	
	#choose which icon to add
	var icon_sprite
	if score <= 21:
		icon_sprite = icon_sprite_path
	else:
		icon_sprite = inverted_icon_sprite_path
		score = 21 #so we don't draw more than 21 icons
	
	#add the icons
	for i in score:
		var new_sprite = Sprite.new()
		new_sprite.texture = icon_sprite
		new_sprite.hframes = 4
		new_sprite.add_to_group("suit_icons")
		add_child(new_sprite)
		new_sprite.position = Vector2(10, 230 - i * 11) #score bar image is 239 high so this will mean icons go bottom up
	
	if get_parent().moon_shroud_effect_active: 
		#play pile shrouded so hide score too
		$ScoreLabel.text = "?"
		$ScoreLabel.rect_position = Vector2(6, -25)
		if $ExcessLabel.text.length() > 0:
			$ExcessLabel.text = "?"
		var suit_icons_to_remove = []
		for child in get_children():
			if child.is_in_group("suit_icons"):
				suit_icons_to_remove.append(child)
		for child in suit_icons_to_remove:
			child.queue_free()
	

func highlight_scores(start_score, end_score):
	if end_score > 21:
		end_score = 21
	
	var score = end_score - start_score + 1
	for i in score:
		var new_sprite = Sprite.new()
		new_sprite.texture = icon_highlight_path
		new_sprite.hframes = 4
		new_sprite.add_to_group("suit_icon_highlights")
		add_child(new_sprite)
		new_sprite.position = Vector2(10, 230 - i * 11 - (start_score - 1) * 11) #score bar image is 239 high so this will mean icons go bottom up

func remove_highlights():
	#remove current icons
	var sprite_array = []
	for child in get_children():
		if child.is_in_group("suit_icon_highlights"):
			sprite_array.append(child)
	for child in sprite_array:
		child.queue_free()
