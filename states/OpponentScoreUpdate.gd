extends Node

var game_controller
var opponent
signal state_exited

func _ready():
	game_controller = get_parent()
	opponent = game_controller.get_node("Opponent")

func enter_state():
	game_controller.current_state = self.name
	
	var score = 0
	for card in opponent.play_pile:
		score = score + card.get_card_value()
	opponent.score = score
	
	opponent.update_UI()
	exit_state()

func exit_state():
	emit_signal("state_exited")
