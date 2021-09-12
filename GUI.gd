extends Node2D

#action frame
var action_frame_resolution: Vector2 = Vector2(800,512)
var action_frame_offset: Vector2 = Vector2(16,16)

#character info view
var character_sprite_pos: Vector2 = Vector2(action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y + 5) + Vector2(32,32)

#signals
signal character_moved

func _ready():
	var character_sprite = get_node("CharacterInfoView/CharacterInfoSprite")
	character_sprite.position = character_sprite_pos
	
	var character_level_label = get_node("CharacterInfoView/CharacterLevelLabel")
	var character_level_label_offset: int = 28
	#character_level_label.ALIGN_RIGHT = 1
	#TODO: align right
	character_level_label.margin_left = character_sprite_pos.x - character_level_label_offset
	character_level_label.margin_right = character_sprite_pos.x + character_level_label_offset
	character_level_label.margin_bottom = character_sprite_pos.y + character_level_label_offset
	character_level_label.margin_top = character_sprite_pos.y - character_level_label_offset
	
	var character_info_label = get_node("CharacterInfoView/CharacterInfoLabel")
	var character_info_label_offset: int = 40
	character_info_label.margin_left = character_sprite_pos.x + character_info_label_offset
	character_info_label.margin_top = character_sprite_pos.y - character_level_label_offset
	
	var button_size: Vector2 = Vector2(175,100)
	
	var gui_button_1 = get_node("GUIButton1")
	gui_button_1.margin_left = action_frame_resolution.x + 2*action_frame_offset.x
	gui_button_1.margin_right = action_frame_resolution.x + 2*action_frame_offset.x + button_size.x
	gui_button_1.margin_top = action_frame_offset.y
	gui_button_1.margin_bottom = action_frame_offset.y + button_size.y
	
	var gui_button_2 = get_node("GUIButton2")
	gui_button_2.margin_left = action_frame_resolution.x + 2*action_frame_offset.x
	gui_button_2.margin_right = action_frame_resolution.x + 2*action_frame_offset.x + button_size.x
	gui_button_2.margin_top = action_frame_offset.y + button_size.y
	gui_button_2.margin_bottom = action_frame_offset.y + button_size.y + button_size.y
	


func _on_Character_character_level_up(level):
	get_node("CharacterInfoView/CharacterLevelLabel").text = str(level)


func _on_Character_finished_moving(position):
	emit_signal("character_moved")


func _on_GUIButton2_pressed():
	var deck_contents = []
	var suits = ["Spades", "Clubs", "Diamonds", "Hearts"]
	for n in 52:
		deck_contents.append(n+1)
	print(deck_contents)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in deck_contents.size():
		var random = i + rng.randi_range(0,51 - i)
		var temp = deck_contents[random]
		deck_contents[random] = deck_contents[i]
		deck_contents[i] = temp
	
	print(deck_contents)
	
	var card = "001"
	print (CardList.card_dictionary.get(card).name)
