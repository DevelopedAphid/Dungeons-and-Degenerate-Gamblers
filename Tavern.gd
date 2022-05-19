extends Node2D

func _ready():
	if PlayerSettings.last_game_result == "won":
		var rewards = []
		for i in 3:
			rewards.append(int(rand_range(1, CardList.card_dictionary.size())))
		$OverworldUI.show_rewards(rewards)
	elif PlayerSettings.last_game_result == "lost":
		get_node("YSort/Player_Overworld").position = Vector2(-20, 60)
		PlayerSettings.player_deck = []
		PlayerSettings.player_hitpoints = 100
		PlayerSettings.chosen_suit = ""
	
	PlayerSettings.last_game_result = ""
