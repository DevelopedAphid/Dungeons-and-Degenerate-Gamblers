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
		game_controller.player_last_turn_result = ""
		game_controller.opponent_last_turn_result = ""
	else: 
		play_should_continue = true
	
	exit_state()

func exit_state():
	emit_signal("state_exited", play_should_continue)

func compare_score_and_deal_damage():
	var battle_scene = game_controller.get_node("BattleScene")
	battle_scene.hide_shields()
	
	var player_score = player.score
	var opponent_score = opponent.score
	if player.score > 21: #busted
		player_score = 0
	if opponent.score > 21: #busted
		opponent_score = 0
	
	battle_scene.play_attack_animation(bool(player_score), bool(opponent_score))
	
	var damage = player_score - opponent_score
	var winner
	var loser
	if damage > 0:
		winner = player
		loser = opponent
	elif damage < 0:
		winner = opponent
		loser = player
		damage = abs(damage)

	var spades = 0
	var clubs = 0
	var diamonds = 0
	var hearts = 0
	var negative_spades = 0
	var negative_clubs = 0
	var negative_diamonds = 0
	var negative_hearts = 0
	if damage > 0: #if there is damage to apply then apply it
		if winner.score == 21: #blackjacks trigger special effects
			for card in winner.play_pile: #find which effects to trigger based on suits involved in the blackjack
				if card.card_suit == "spades":
					spades += card.card_value
				elif card.card_suit == "clubs":
					clubs += card.card_value
				elif card.card_suit == "diamonds":
					diamonds += card.card_value
				elif card.card_suit == "hearts":
					hearts += card.card_value
				elif card.card_suit == "all_suits_at_once": #Jack of All Trades triggers the effect of all 4 suits
					spades += 10
					clubs += 10
					diamonds += 10
					hearts += 10
				elif card.card_suit == "negative_spades": #these cards have negative value so have to minus by the value rather than add
					negative_spades -= card.card_value
				elif card.card_suit == "negative_clubs":
					negative_clubs -= card.card_value
				elif card.card_suit == "negative_diamonds":
					negative_diamonds -= card.card_value
				elif card.card_suit == "negative_hearts":
					negative_hearts -= card.card_value
			if loser.judgment_shield_active: #if judgment shield active the loser takes no damamge from winners blackjack
				damage = 0
				clubs = 0
				loser.judgment_shield_active = false #disable judgment shield once used once
			if winner.star_effect_active: #double damage if the star effect active
				damage = damage * 2
				winner.star_effect_active = false #disable star effect once used once
		#clubs deal double damage on 21
		#shield (if earned last round) blocks damage
		#cannot deal negative damage
		loser.damage(max(0, (damage + clubs - loser.shieldpoints)))
		winner.damage(negative_clubs) #negative clubs deal damage to the winner if involved in blackjack
		if winner.name == "Player":
			winner.chips += diamonds
			winner.chips -= negative_diamonds
		winner.heal(hearts, Vector2(240, 150)) #hearts heal the player on 21
		loser.heal(negative_hearts, Vector2(240, 150)) #negative hearts heal opponent on player 21
		#reset loser shiled to 0 and (if blackjacked with spades) set up winners shield
		loser.shieldpoints = negative_spades #negative spades give the opponent a shield next round
		winner.shieldpoints = spades
	
	#update the relevant UI elements
	battle_scene.update_health_points()
	player.get_node("ChipCounter").change_chip_number(player.chips)
	battle_scene.display_shields(player.shieldpoints, opponent.shieldpoints)
	
	if player.hitpoints <= 0:
		get_parent().macro_controller.last_game_result = "lost"
		get_parent().emit_signal("game_over", "player_lost")
	elif opponent.hitpoints <= 0:
		get_parent().macro_controller.last_game_result = "won"
		get_parent().macro_controller.player_hitpoints = player.hitpoints
		get_parent().macro_controller.player_chips = player.chips
		get_parent().emit_signal("game_over", "player_won")
