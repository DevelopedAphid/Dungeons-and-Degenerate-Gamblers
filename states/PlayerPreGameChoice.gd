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
	get_parent().get_node("BattleScene/PlayerHealthLabel").text = str(player.hitpoints) + "/" + str(player.max_hitpoints)
	get_parent().get_node("BattleScene/OpponentHealthLabel").text = str(opponent.hitpoints) + "/" + str(opponent.max_hitpoints)
	player.get_node("ChipCounter").change_chip_number(player.chips)
	exit_state() #for now we just skip this state completely

func exit_state():
	emit_signal("state_exited")
