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
	
	player.discard_played_cards()
	opponent.discard_played_cards()
	
	if player.decaying_healing > 0:
		player.heal(player.decaying_healing, Vector2(240, 150))
		player.decaying_healing -= 1
	if opponent.decaying_healing > 0:
		opponent.heal(opponent.decaying_healing, Vector2(240, 150))
		opponent.decaying_healing -= 1
	
	if player.rounds_to_skip > 0:
		player.rounds_to_skip -= 1
	if opponent.rounds_to_skip > 0:
		opponent.rounds_to_skip -= 1
	if player.chariot_effect_active:
		opponent.rounds_to_skip += 1
		player.chariot_effect_active = false
	if opponent.chariot_effect_active:
		player.rounds_to_skip += 1
		opponent.chariot_effect_active = false
	
	exit_state()

func exit_state():
	emit_signal("state_exited")
