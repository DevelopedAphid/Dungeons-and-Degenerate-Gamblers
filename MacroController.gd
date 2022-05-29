extends Node2D

var chosen_suit = ""

var player_deck = []
var player_sprite = "res://assets/art/characters/player1.png"
var player_max_hitpoints = 100
var player_hitpoints = 100

var opponent_deck = []
var opponent_sprite = ""
var opponent_health_points = 0

var last_game_result = ""

var game_controller

func _ready():
	$ChoiceUI.change_choices_visibility(true)
	#todo: set_up_new_game function for game controller

func start_a_game():
	#instance first npc for testing - should later be loaded depending on level/progress todo:
	opponent_deck = ["057", "058", "056", "044", "006", "006"]
	opponent_sprite = "res://assets/art/characters/wizard.png"
	opponent_health_points = 50
	
	game_controller = load("res://CardMat.tscn").instance()
	game_controller.connect("game_over", self, "on_GameController_game_over")
	add_child(game_controller)

func _on_OverworldUI_starting_suit_chosen():
	start_a_game()

func on_GameController_game_over(result):
	if result == "player_won":
		remove_child(game_controller)
		$ChoiceUI.present_rewards()
	elif result == "player_lost":
		remove_child(game_controller)


func _on_OverworldUI_reward_card_chosen():
	start_a_game()
