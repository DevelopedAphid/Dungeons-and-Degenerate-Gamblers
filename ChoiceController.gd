extends Control

var grid_controller
var choices

signal choice_made(choice_made)

func _ready():
	grid_controller = get_node("ChoiceGridContainer")
#	_on_Player_card_choice_to_make(["014","051"])

func _on_Player_card_choice_to_make(choice_array):
	choices = choice_array
	for choice in choices:
		var button = Button.new()
		grid_controller.add_child(button)
		var file_path = "res://art/card-art/" + choice + ".png"
		button.icon = load(file_path)
		button.flat = true
		button.expand_icon = true
		button.rect_min_size.x = 360
		button.rect_min_size.y = 600
		button.connect("pressed", self, "_on_Player_card_choice_selected", [choice])

func _on_Player_card_choice_selected(choice):
	emit_signal("choice_made", choice)
	get_parent().update_UI()
	choices = null
	
	for child in grid_controller.get_children():
		child.queue_free()
