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
var dialogue_showing = false
var dialogue_type = ""

func _ready():
	allow_choices()
	choice_UI.change_choices_visibility(true)

func allow_choices():
	choice_UI = load	("res://ChoiceUI.tscn").instance()
	choice_UI.connect("starting_suit_chosen", self, "_on_ChoiceUI_starting_suit_chosen")
	choice_UI.connect("reward_card_chosen", self, "_on_ChoiceUI_reward_card_chosen")
	choice_UI.connect("shop_card_chosen", self, "_on_ChoiceUI_shop_card_chosen")
	add_child(choice_UI)

func start_a_game():
	var encounter_key = get_encounter_key()
	var encounter_type = $EncounterList.encounter_dictionary[encounter_key].type
	
	if encounter_type == "opponent":
		opponent_sprite = $EncounterList.encounter_dictionary[encounter_key].sprite
		opponent_health_points = $EncounterList.encounter_dictionary[encounter_key].healthpoints
		opponent_deck = $EncounterList.encounter_dictionary[encounter_key].deck
		
		game_controller = load("res://GameController.tscn").instance()
		game_controller.connect("game_over", self, "on_GameController_game_over")
		add_child(game_controller)
		
		$DialogueManager.set_dialogue_text($EncounterList.encounter_dictionary[encounter_key].start_dialogue)
		dialogue_type = "start"
	
	if encounter_type == "shop":
		allow_choices()
		choice_UI.show_shop()

func get_encounter_key() -> String:
	var encounter_key = floor_name + "." + str(encounter_count)
	return encounter_key

func _on_ChoiceUI_starting_suit_chosen():
	choice_UI.queue_free()
	start_a_game()

func _on_ChoiceUI_reward_card_chosen():
	choice_UI.queue_free()
	start_a_game()

func _on_ChoiceUI_shop_card_chosen():
	choice_UI.queue_free()
	encounter_count += 1
	start_a_game()

func on_GameController_game_over(result):
	if result == "player_won":
		var encounter_key = get_encounter_key()
		$DialogueManager.set_dialogue_text($EncounterList.encounter_dictionary[encounter_key].end_dialogue)
		dialogue_type = "end"
		allow_choices()
		choice_UI.present_rewards()
		remove_child(game_controller)
		player_chips += $EncounterList.encounter_dictionary[get_encounter_key()].chip_reward
		encounter_count += 1
	elif result == "player_lost":
		remove_child(game_controller)

func _on_DialogueManager_dialogue_cleared():
	dialogue_showing = false
	if dialogue_type == "start":
		game_controller.transition_to("PlayerPreGameChoice", {})
	elif dialogue_type == "end":
		pass
	dialogue_type = ""

func _on_DialogueManager_dialogue_set():
	dialogue_showing = true
	#todo: unsure if this is needed
