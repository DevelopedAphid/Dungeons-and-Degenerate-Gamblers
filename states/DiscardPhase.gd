extends Node

var game_controller
signal state_exited

var player
var opponent

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")
	opponent = game_controller.get_node("Opponent")

func enter_state():
	game_controller.current_state = self.name
	player.discard_played_cards()
	opponent.discard_played_cards()
	exit_state()

func exit_state():
	emit_signal("state_exited")
