extends Node

var game_controller
signal state_exited

func _ready():
	game_controller = get_parent()

func enter_state():
	game_controller.current_state = self.name
	print("entered state: " + str(self.name))
	exit_state() #for now we just skip this state completely

func exit_state():
	print("exited state: " + str(self.name))
	emit_signal("state_exited")
