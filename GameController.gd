extends Node

var rng
var player
var opponent
var current_turn
var player_last_turn_result
var opponent_last_turn_result

var current_state

func _ready():
	player = get_node("Player")
	opponent = get_node("Opponent")
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var first_card_index
	var starting_suit = PlayerSettings.chosen_suit
	if starting_suit == "spades":
		first_card_index = 1
	elif starting_suit == "clubs":
		first_card_index = 14
	elif starting_suit == "diamonds":
		first_card_index = 27
	elif starting_suit == "hearts":
		first_card_index = 40
	
	for n in 13: #all cards of one suit
		player.add_card_to_deck(n + first_card_index)
		opponent.add_card_to_deck(n + 1) #for now always spades

	#add the birthday card and the joker and the magic trick card and the red joker
	player.add_card_to_deck(69)
	player.add_card_to_deck(70)
	player.add_card_to_deck(71)
	player.add_card_to_deck(72)
	
	player.build_draw_pile()
	opponent.build_draw_pile()
	
	current_turn = "player"
	player_last_turn_result = "hit"
	opponent_last_turn_result = "hit"
	
	transition_to("PlayerPreGameChoice", {})

func transition_to(target_state: String, _data: Dictionary):
	if not has_node(target_state):
		print("target_state: '" + target_state + "' does not exist")
	
	current_state = target_state
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
		transition_to("PlayerWaitForFirstPlayAreaInput", {})
	else:
		transition_to("DiscardPhase", {})

func _on_DiscardPhase_state_exited():
	transition_to("PlayerWaitForFirstPlayAreaInput", {})
