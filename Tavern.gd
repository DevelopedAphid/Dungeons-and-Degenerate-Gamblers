extends Node2D

func _ready():
	if PlayerSettings.last_game_result == "won":
		var rewards = []
		for i in 3:
			rewards.append(int(rand_range(1, CardList.card_dictionary.size())))
		$OverworldUI.show_rewards(rewards)
