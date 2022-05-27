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
	
	player.get_node("ScoreBar").update_score(player.score)
	opponent.get_node("ScoreBar").update_score(opponent.score)
	
	exit_state()

func exit_state():
	emit_signal("state_exited")
