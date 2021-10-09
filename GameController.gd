extends Node

var rng
var player
var opponent
var current_turn
var player_last_turn_result
var opponent_last_turn_result

var current_state
enum States {PREPARE_DRAW_PILES, PLAYER_PRE_GAME_CHOICE, OPPONENT_PRE_GAME_CHOICE, 
			PLAYER_START_OF_TURN_ACTIONS, PLAYER_WAIT_FOR_FIRST_PLAY_AREA_INPUT, PLAYER_PLAY_CARD, 
			PLAYER_WAIT_FOR_CARD_CHOICE, PLAYER_SCORE_UPDATE, PLAYER_WAIT_FOR_LAST_PLAY_AREA_INPUT,
			OPPONENT_START_OF_TURN_ACTIONS, OPPONENT_WAIT_FOR_FIRST_PLAY_AREA_INPUT, OPPONENT_PLAY_CARD, 
			OPPONENT_WAIT_FOR_CARD_CHOICE, OPPONENT_SCORE_UPDATE, OPPONENT_WAIT_FOR_LAST_PLAY_AREA_INPUT,
			AFTER_ROUND_PHASE, 
			PLAYER_DISCARD, PLAYER_WAIT_FOR_DISCARD_CHOICE, 
			OPPONENT_DISCARD, OPPONENT_WAIT_FOR_DISCARD_CHOICE}

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
	
	#add the birthday card and the joker and the magic trick card
	player.add_card_to_deck(70)
	player.add_card_to_deck(69)
	player.add_card_to_deck(71)
	
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

func _on_Player_turn_ended(action):
	player_last_turn_result = action
	current_turn = "opponent"
	if opponent.get_node("AI").will_hit() == true:
		opponent.draw_top_card()
	else:
		opponent.end_turn("stay")

func _on_Opponent_turn_ended(action):
	opponent_last_turn_result = action
	current_turn = "player"
	check_if_round_ended()

func check_if_round_ended():
	if player_last_turn_result == "stay" && opponent_last_turn_result == "stay":
		end_round()

func end_round():
	compare_score_and_deal_damage()
	player.discard_played_cards()
	opponent.discard_played_cards()

func compare_score_and_deal_damage():
	var player_score = player.score
	var opponent_score = opponent.score
	if player_score > 21: #busted
		player_score = 0
	if opponent_score > 21: #busted
		opponent_score = 0
	
	#should be replaced by a "deal damage" method later in case we add damage multiplier effects or anything
	var damage = player_score - opponent_score
	if damage > 0: #player won, deal difference of scores as damage
		opponent.hitpoints = opponent.hitpoints - damage
	if damage < 0: #opponent won, deal difference of scores as damage
		player.hitpoints = player.hitpoints + damage

func _on_PlayerPreGameChoice_state_exited():
	transition_to("OpponentPreGameChoice", {})

func _on_OpponentPreGameChoice_state_exited():
	transition_to("PlayerStartOfTurnActions", {})

func _on_PlayerStartOfTurnActions_state_exited():
	transition_to("PlayerWaitForFirstPlayAreaInput", {})

func _on_PlayerWaitForFirstPlayAreaInput_state_exited(action_taken):
	if action_taken == "hit":
		transition_to("PlayerWaitForCardChoice", {})
	elif action_taken == "stay":
		transition_to("PlayerScoreUpdate", {})

func _on_PlayerWaitForCardChoice_state_exited():
	transition_to("PlayerWaitForFirstPlayAreaInput", {})

func _on_PlayerScoreUpdate_state_exited():
	pass # Replace with function body.
