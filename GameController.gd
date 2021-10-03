extends Node2D

var rng
var player
var opponent
var current_turn
var player_last_turn_result
var opponent_last_turn_result

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
		opponent.add_card_to_deck(n + 1) #always spades
	
	#add the birthday card and the joker
	player.add_card_to_deck(70)
	player.add_card_to_deck(69)
	
	player.build_draw_pile()
	opponent.build_draw_pile()
	
	current_turn = "player"
	player_last_turn_result = "hit"
	opponent_last_turn_result = "hit"

func _on_HitButton_pressed():
	if current_turn == "player":
		player.draw_top_card()

func _on_StayButton_pressed():
	if current_turn == "player":
		player.end_turn("stay")

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
