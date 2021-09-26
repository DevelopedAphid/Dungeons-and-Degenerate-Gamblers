extends Node2D

var rng
var player
var opponent

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
	
	player.build_draw_pile()
	opponent.build_draw_pile()

func _on_HitButton_pressed():
	player.draw_top_card()

func _on_StayButton_pressed():
	player.end_turn()

func _on_Player_turn_ended():
	if opponent.get_node("AI").will_hit() == true:
		opponent.draw_top_card()

func _on_Opponent_turn_ended():
	pass # Replace with function body.



