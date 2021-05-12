extends Node2D

#action frame
var action_frame_resolution: Vector2 = Vector2(800,512)
var action_frame_offset: Vector2 = Vector2(15,15)

#character info view
var character_sprite_pos: Vector2 = Vector2(action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y + 5) + Vector2(32,32)

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
	
