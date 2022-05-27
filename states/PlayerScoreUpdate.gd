extends Node

var game_controller
var player
signal state_exited

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")

func enter_state():
	game_controller.current_state = self.name
	
	var score = 0
	for card in player.play_pile:
		score = score + card.get_card_value()
	player.score = score
	
	player.get_node("ScoreBar").update_score(player.score)
	
	exit_state()

func exit_state():
	emit_signal("state_exited")
