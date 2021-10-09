extends Node

var game_controller
var player
signal state_exited

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")

func enter_state():
	game_controller.current_state = self.name
	print("entered state: " + str(self.name))

func exit_state(action_taken):
	print("exited state: " + str(self.name))
	emit_signal("state_exited", action_taken)

func _on_HitButton_pressed():
	if is_current_state():
		player.draw_top_card()
		exit_state("hit")

func _on_StayButton_pressed():
	if is_current_state():
		player.end_turn("stay")
		exit_state("stay")

func is_current_state() -> bool: 
	if game_controller.current_state == self.name:
		return true
	else:
		return false
