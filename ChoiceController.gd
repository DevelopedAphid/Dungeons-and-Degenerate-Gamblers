extends Node2D

var grid_controller

func _ready():
	grid_controller = get_node("ChoiceGridContainer")

func _on_Player_card_choice_to_make(choice_array, card):
	for choice in choice_array:
		var button = Button.new()
		grid_controller.add_child(button)
		var file_path = "res://art/card-art/" + choice + ".png"
		button.icon = load(file_path)
		button.flat = true
		button.connect("pressed", self, "_on_Player_card_choice_selected", [choice, card])

func _on_Player_card_choice_selected(choice, card):
	card.set_card_id(choice)
	#this should really move back to the original place where signal came from and use a yield to wait for the choice before finishing playing the card and setting the score
	get_parent().get_node("Player").update_UI()
	
	#remove the buttons at the end of this function!
