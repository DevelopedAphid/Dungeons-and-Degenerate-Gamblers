extends Node

var game_controller
signal state_exited

func _ready():
	game_controller = get_parent()

func enter_state():
	game_controller.current_state = self.name
	game_controller.get_node("BattleScene").set_turn_indicator(false)
	exit_state()

func exit_state():
	emit_signal("state_exited")
