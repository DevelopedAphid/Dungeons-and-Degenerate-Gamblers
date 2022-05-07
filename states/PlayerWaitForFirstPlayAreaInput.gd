extends Node

var game_controller
var player
signal state_exited

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")

func enter_state():
	game_controller.current_state = self.name
	
	if game_controller.player_last_turn_result == "stay":
		exit_state("stay")

func exit_state(action_taken):
	emit_signal("state_exited", action_taken)

func _on_StayButton_pressed():
	if is_current_state():
		game_controller.player_last_turn_result = "stay"
		exit_state("stay")

func is_current_state() -> bool: 
	if game_controller.current_state == self.name:
		return true
	else:
		return false

func _on_HitButton_pressed():
	if is_current_state():
		player.draw_top_card()
		game_controller.player_last_turn_result = "hit"
		exit_state("hit")
