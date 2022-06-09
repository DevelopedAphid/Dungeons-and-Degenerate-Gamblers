extends Node

var game_controller
signal state_exited

func _ready():
	game_controller = get_parent()

func enter_state():
	game_controller.current_state = self.name
	
	get_parent().update_scores() 
	
	game_controller.get_node("BattleScene").set_turn_indicator(true)
	
	exit_state()

func exit_state():
	emit_signal("state_exited")
