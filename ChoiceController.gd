extends Control

var grid_controller
var choices
var origin

signal choice_made(choice_made)
signal choice_made_(origin_card, choice_array, choice_index)

func _ready():
	grid_controller = get_node("ChoiceGridContainer")

func _on_Player_card_choice_to_make(origin_card, choice_array):
	self.visible = true
	origin = origin_card
	choices = choice_array
	
	if choice_array.size() > 4:
		grid_controller.columns = 4
	else:
		grid_controller.columns = choice_array.size()
	
	var card_button_texture = load("res://assets/art/card_sprite_sheet.png")
	for choice in choices.size():
		var card_button = TextureButton.new()
		var card_button_sprite = Sprite.new()
		card_button_sprite.texture = card_button_texture
		card_button_sprite.hframes = 13
		card_button_sprite.vframes = 6
		
		card_button_sprite.set_z_index(2) #bring choices to the front
		
		var current_choice = choice_array[choice]
		
		#set card art according to position in sprite sheet
		var card_sprite_index
		if typeof(current_choice) == 4: #if input is a string
			card_sprite_index = float(current_choice) - 1
		else: #must be a card instead
			card_sprite_index = float(current_choice.get_card_id()) - 1
		var row = floor(card_sprite_index/13)
		var col = fmod(card_sprite_index, 13)
		card_button_sprite.frame_coords.x = col
		card_button_sprite.frame_coords.y = row
		
#		card_button_sprite.position = Vector2(57/2, 89/2) #half the size of the sprite to centre it
		card_button_sprite.centered = false
		card_button.add_child(card_button_sprite)
		grid_controller.add_child(card_button)
		card_button.size_flags_horizontal = SIZE_EXPAND_FILL
		card_button.size_flags_vertical = SIZE_EXPAND_FILL

		if typeof(current_choice) == 4: #if input is a string
#			card_button.text = CardList.card_dictionary[choice_array[choice]].name
			card_button.connect("pressed", self, "_on_Player_card_choice_selected", [choice])
		else: #must be a card instead
#			card_button.text = current_choice.get_card_name()
			card_button.connect("pressed", self, "_on_Player_card_choice_selected", [choice])

func _on_Player_card_choice_selected(choice):
	emit_signal("choice_made_", origin, choices, choice)
	
	emit_signal("choice_made", choice)
	get_parent().update_UI()
	choices = null
	
	for child in grid_controller.get_children():
		child.queue_free()
	
	self.visible = false
