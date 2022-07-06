extends Node2D

var icon_sprite_path = preload("res://assets/art/suit_icons_9_9.png")
var inverted_icon_sprite_path = preload("res://assets/art/suit_icons_inverted_9_9.png")
var icon_highlight_path = preload("res://assets/art/suit_icon_highlights_9_9.png")

var current_score = 0

onready var font = Fonts.font_pixel_5_9

var suit_sprite_array = []

func _ready():
	$ScoreLabel.add_font_override("font", font)
	$ExcessLabel.add_font_override("font", font)
	
	for child in $CardSprite.get_children():
		suit_sprite_array.append(child)

func update_score():
	#----- score card ------#
	#first reset the score card to nly have gray squares
	for sprite in suit_sprite_array:
		sprite.frame = 16 #gray square is at frame 16
	
	#then get all the card in play and find their scores and suit
	var score = 0
	var suit_array = []
	for card in get_parent().play_pile:
		for i in card.get_card_value():
			if card.is_focused and not card.card_shrouded:
				suit_array.append(card.card_suit + "_highlighted")
			else:
				suit_array.append(card.card_suit)
		score = score + card.get_card_value()
	get_parent().score = score
	
	#then apply the suits to the sprites
	for i in suit_array.size():
		if i <= 20 and i >= 0:
			var frame_index = 0
			if score <= 21:
				match suit_array[i]: #select correct frame_index based on card_suit
					"spades":
						frame_index = 0
					"clubs":
						frame_index = 1
					"diamonds":
						frame_index = 10
					"hearts":
						frame_index = 11
					"spades_highlighted":
						frame_index = 4
					"clubs_highlighted":
						frame_index = 5
					"diamonds_highlighted":
						frame_index = 14
					"hearts_highlighted":
						frame_index = 15
					"special":
						frame_index = 17
					"special_highlighted":
						frame_index = 18
					"all_suits_at_once":
						frame_index = 21
					"all_suits_at_once_highlighted":
						frame_index = 22
			elif score > 21:
				match suit_array[i]: #same as above but inverted
					"spades":
						frame_index = 8
					"clubs":
						frame_index = 9
					"diamonds":
						frame_index = 2
					"hearts":
						frame_index = 3
					"spades_highlighted":
						frame_index = 12
					"clubs_highlighted":
						frame_index = 13
					"diamonds_highlighted":
						frame_index = 6
					"hearts_highlighted":
						frame_index = 7
					"special":
						frame_index = 19
					"special_highlighted":
						frame_index = 20
					"all_suits_at_once":
						frame_index = 23
					"all_suits_at_once_highlighted":
						frame_index = 24
			suit_sprite_array[i].frame = frame_index
	
	#------ score card ------#
	
	$ScoreLabel.text = str(score)
	$ExcessLabel.visible = false
	if score > 21:
		if get_parent().blackjack_cap_type != "none":
			$ScoreLabel.text = str(21)
			$ExcessLabel.text = str(score - 21)
			$ExcessLabel.visible = true
	
	if get_parent().moon_shroud_effect_active: 
		#play pile shrouded so hide score too
		$ScoreLabel.text = "?"
		if $ExcessLabel.text.length() > 0:
			$ExcessLabel.text = "?"
		for sprite in suit_sprite_array:
			sprite.frame = 25
