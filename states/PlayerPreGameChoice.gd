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
	#update the relevant UI elements
	get_parent().get_node("BattleScene").update_health_points()
	player.get_node("ChipCounter").change_chip_number(player.chips)
	exit_state() 

func exit_state():
	emit_signal("state_exited")
