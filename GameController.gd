extends Node

# warning-ignore:unused_signal
# called by AfterRoundPhase since that's where we check hp - but signal for this node in case we have other win conditions later
signal game_over(result)

var rng
var player
var opponent
var current_turn
var player_last_turn_result
var opponent_last_turn_result
var state_label

var current_state = ""

onready var macro_controller = get_parent()

func _ready():
	player = get_node("Player")
	opponent = get_node("Opponent")
	state_label = get_node("StateLabel")
	
	rng = RandomNumberGenerator.new()
	rng.randomize()

	player.build_draw_pile_from_deck(macro_controller.player_deck, macro_controller.player_x_values)
	opponent.build_draw_pile_from_deck(macro_controller.opponent_deck, macro_controller.opponent_x_values)
	
	current_turn = "player"
	player_last_turn_result = "hit"
	opponent_last_turn_result = "hit"
	
	update_scores()

func update_scores():
	player.get_node("ScoreBar").update_score()
	opponent.get_node("ScoreBar").update_score()

func transition_to(target_state: String, _data: Dictionary):
#	print("attempting state transition from: " + current_state + " to: " + target_state)
	if not has_node(target_state):
		print("target_state: '" + target_state + "' does not exist")
	
#	print("yielding during transition from " + current_state)
	if player.cards_currently_moving.size() > 0:
		yield(player, "UI_update_completed")
	if opponent.cards_currently_moving.size() > 0:
		yield(opponent, "UI_update_completed")
#	print("resuming after transition to " + target_state)
	
	update_scores()
	
	current_state = target_state
	state_label.text = current_state
	get_node(target_state).enter_state()

func _on_PlayerPreGameChoice_state_exited():
	transition_to("OpponentPreGameChoice", {})

func _on_OpponentPreGameChoice_state_exited():
	transition_to("PlayerStartOfTurnActions", {})

func _on_PlayerStartOfTurnActions_state_exited():
	transition_to("PlayerWaitForFirstPlayAreaInput", {})

func _on_PlayerWaitForFirstPlayAreaInput_state_exited(player_action_taken):
	if player_action_taken == "hit":
		transition_to("PlayerWaitForCardChoice", {})
	elif player_action_taken == "stay":
		transition_to("PlayerScoreUpdate", {})

func _on_PlayerWaitForCardChoice_state_exited():
	transition_to("PlayerScoreUpdate", {})

func _on_PlayerScoreUpdate_state_exited():
	transition_to("OpponentStartOfTurnActions", {})

func _on_OpponentStartOfTurnActions_state_exited():
	transition_to("OpponentWaitForFirstPlayAreaInput", {})

func _on_OpponentWaitForFirstPlayAreaInput_state_exited(action_taken):
	if action_taken == "hit":
		transition_to("OpponentWaitForCardChoice", {})
	elif action_taken == "stay":
		transition_to("OpponentScoreUpdate", {})

func _on_OpponentWaitForCardChoice_state_exited():
	transition_to("OpponentScoreUpdate", {})

func _on_OpponentScoreUpdate_state_exited():
	transition_to("AfterRoundPhase", {})

func _on_AfterRoundPhase_state_exited(play_should_continue):
	if play_should_continue:
		transition_to("PlayerStartOfTurnActions", {})
	else:
		transition_to("DiscardPhase", {})

func _on_DiscardPhase_state_exited():
	transition_to("PlayerStartOfTurnActions", {})
