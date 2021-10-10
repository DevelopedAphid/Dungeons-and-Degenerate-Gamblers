extends Node

var game_controller
var player
var choice_controller
var choice_controller_grid
signal state_exited

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")
	choice_controller = game_controller.get_node("Player/ChoiceController")
	choice_controller.connect("choice_made", self, "_on_Choice_controller_choice_made")

func enter_state():
	game_controller.current_state = self.name
	
	if choice_controller.choices != null && choice_controller.choices.size() > 0: #there is a choice to be made
		choice_controller.visible = true #swap for choice_controller.show choices or something later
	else:
		exit_state()

func exit_state():
	emit_signal("state_exited")

func _on_Player_card_effect_ended():
	exit_state()
