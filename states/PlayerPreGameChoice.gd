extends Node

var game_controller
var player
var opponent
signal state_exited

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")
	opponent = game_controller.get_node("Opponent")

func enter_state():
	game_controller.current_state = self.name
	exit_state() 

func exit_state():
	emit_signal("state_exited")
