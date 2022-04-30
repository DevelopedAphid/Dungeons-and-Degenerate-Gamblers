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
		opponent.hitpoints = opponent.hitpoints - damage
	if damage < 0: #opponent won, deal difference of scores as damage
		player.hitpoints = player.hitpoints + damage
	
	player.update_UI()
