extends Node

var game_controller
var opponent
var opponent_AI
signal state_exited(action_taken)

func _ready():
	game_controller = get_parent()
	opponent = game_controller.get_node("Opponent")
	opponent_AI = opponent.get_node("AI")

func enter_state():
	game_controller.current_state = self.name
	if is_current_state():
		if game_controller.opponent_last_turn_result == "stay":
			exit_state("stay")
		elif opponent.rounds_to_skip > 0:
			game_controller.opponent_last_turn_result = "stay"
			exit_state("stay")
		elif opponent_AI.will_hit():
			opponent.draw_top_card()
			game_controller.opponent_last_turn_result = "hit"
			exit_state("hit")
		else:
			game_controller.opponent_last_turn_result = "stay"
			exit_state("stay")

func exit_state(action_taken):
	emit_signal("state_exited", action_taken)

func is_current_state() -> bool: 
	if game_controller.current_state == self.name:
		return true
	else:
		return false
