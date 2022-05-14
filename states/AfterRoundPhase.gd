extends Node

var game_controller
var player
var opponent
var play_should_continue: bool
signal state_exited(play_should_continue)

func _ready():
	game_controller = get_parent()
	player = game_controller.get_node("Player")
	opponent = game_controller.get_node("Opponent")

func enter_state():
	game_controller.current_state = self.name
	
	if game_controller.player_last_turn_result == "stay" && game_controller.opponent_last_turn_result == "stay":
		play_should_continue = false
		compare_score_and_deal_damage()
		game_controller.player_last_turn_result = "hit"
		game_controller.opponent_last_turn_result = "hit"
	else: 
		play_should_continue = true
	
	exit_state()

func exit_state():
	emit_signal("state_exited", play_should_continue)

func compare_score_and_deal_damage():
	var player_score = player.score
	var opponent_score = opponent.score
	if player.score > 21: #busted
		player_score = 0
	if opponent.score > 21: #busted
		opponent_score = 0
	
	#todo: should be replaced by a "deal damage" method later in case we add damage multiplier effects or anything
	var damage = player_score - opponent_score
	if damage > 0: #player won, deal difference of scores as damage
		var spades = 0
		var clubs = 0
		var diamonds = 0
		var hearts = 0
		if player_score == 21:
			for card in player.play_pile:
				if card.card_suit == "spades":
					spades += card.card_value
				elif card.card_suit == "clubs":
					clubs += card.card_value
				elif card.card_suit == "diamonds":
					diamonds += card.card_value
				elif card.card_suit == "hearts":
					hearts += card.card_value
		opponent.bleedpoints += spades
		opponent.hitpoints -= (damage + clubs) #clubs deal double damage on 21
		print("add " + str(diamonds) + " cash to the players reward")
		player.hitpoints += hearts #hearts heal the player on 21
		if player.hitpoints > player.max_hitpoints:
			player.hitpoints = player.max_hitpoints
	if damage < 0: #opponent won, deal difference of scores as damage
		player.hitpoints += damage
	
	if opponent.bleedpoints > 0:
		opponent.hitpoints -= opponent.bleedpoints
		opponent.bleedpoints -= 1
	
	player.update_UI()
	
	if player.hitpoints <= 0:
		PlayerSettings.last_game_result = "lost"
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Tavern.tscn")
	elif opponent.hitpoints <= 0:
		PlayerSettings.last_game_result = "won"
		PlayerSettings.player_hitpoints = player.hitpoints
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Tavern.tscn")
