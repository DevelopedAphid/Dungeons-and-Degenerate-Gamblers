extends Node2D

var chosen_suit = ""

var player_deck = []
var player_sprite = "res://assets/art/characters/player1.png"
var player_max_hitpoints = 100
var player_hitpoints = 100
var player_chips = 0

var opponent_deck = []
var opponent_sprite = ""
var opponent_health_points = 0

var last_game_result = ""

var game_controller
var choice_UI

var floor_name = "tavern"
var encounter_count = 1

func _ready():
	allow_choices()
	choice_UI.change_choices_visibility(true)

func allow_choices():
	choice_UI = load	("res://ChoiceUI.tscn").instance()
	choice_UI.connect("starting_suit_chosen", self, "_on_ChoiceUI_starting_suit_chosen")
	choice_UI.connect("reward_card_chosen", self, "_on_ChoiceUI_reward_card_chosen")
	add_child(choice_UI)

func start_a_game():
	var encounter_key = get_encounter_key()
	opponent_sprite = $EncounterList.encounter_dictionary[encounter_key].sprite
	opponent_health_points = $EncounterList.encounter_dictionary[encounter_key].healthpoints
	opponent_deck = $EncounterList.encounter_dictionary[encounter_key].deck
	
	game_controller = load("res://CardMat.tscn").instance()
	game_controller.connect("game_over", self, "on_GameController_game_over")
	add_child(game_controller)

func get_encounter_key() -> String:
	var encounter_key = floor_name + "." + str(encounter_count)
	return encounter_key

func _on_ChoiceUI_starting_suit_chosen():
	choice_UI.queue_free()
	start_a_game()

func _on_ChoiceUI_reward_card_chosen():
	choice_UI.queue_free()
	start_a_game()

func on_GameController_game_over(result):
	if result == "player_won":
		allow_choices()
		choice_UI.present_rewards()
		remove_child(game_controller)
		player_chips += $EncounterList.encounter_dictionary[get_encounter_key()].chip_reward
		encounter_count += 1
	elif result == "player_lost":
		remove_child(game_controller)
