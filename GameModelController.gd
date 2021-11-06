extends Node

var current_play_table

func _ready():
	current_play_table = get_parent().get_node("Table")
	
	PlayerSettings.connect("player_suit_chosen", self, "create_player_draw_pile")

func create_player_draw_pile(suit):
	current_play_table.clear_table()
	current_play_table.card_spawn_position.z = current_play_table.card_spawn_position.z - 0.6
	current_play_table.card_spawn_position.y = current_play_table.card_spawn_position.y + 0.6
	
	var starting_suit = suit
	var first_card_index
	if suit == "spades":
		first_card_index = 1
	elif suit == "clubs":
		first_card_index = 14
	elif suit == "diamonds":
		first_card_index = 27
	elif suit == "hearts":
		first_card_index = 40
	
	for n in 13: #all cards of one suit
		var new_card = current_play_table.add_new_card(n + first_card_index)
		current_play_table.deal_card_at_position(new_card, current_play_table.card_spawn_position)
