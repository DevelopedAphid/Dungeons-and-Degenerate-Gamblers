extends Control

var grid_controller
var choices

signal choice_made(choice_made)

func _ready():
	grid_controller = get_node("ChoiceGridContainer")

func _on_Player_card_choice_to_make(choice_array):
	choices = choice_array
	if choice_array.size() > 4:
		grid_controller.columns = 4
	else:
		grid_controller.columns = choice_array.size()
	
	for choice in choices.size():
		var button = Button.new()
		grid_controller.add_child(button)
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.size_flags_vertical = SIZE_EXPAND_FILL
		var current_choice = choice_array[choice]
		if typeof(current_choice) == 4: #if input is a string
			button.text = CardList.card_dictionary[choice_array[choice]].name
			button.connect("pressed", self, "_on_Player_card_choice_selected", [choice_array[choice]])
		else: #must be a card instead
			button.text = current_choice.get_card_name()
			button.connect("pressed", self, "_on_Player_card_choice_selected", [choice])

func _on_Player_card_choice_selected(choice):
	emit_signal("choice_made", choice)
	get_parent().update_UI()
	choices = null
	
	for child in grid_controller.get_children():
		child.queue_free()
	
	self.visible = false
