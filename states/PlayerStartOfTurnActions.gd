extends Node

var game_controller
var player
signal state_exited

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")

func enter_state():
	game_controller.current_state = self.name
	
	get_parent().update_scores() 
	
	for card in player.play_pile:
		player.play_card_start_of_turn_effect(card, card.card_id)
	
	exit_state()

func exit_state():
	emit_signal("state_exited")
