extends Node2D

var chosen_suit = ""

var player_deck = []
var player_x_values = []
var player_sprite = "res://assets/art/characters/player.png"
var player_max_hitpoints = 100
var player_hitpoints = 100
var player_chips = 0

var opponent_deck = []
var opponent_x_values = []
var opponent_sprite = ""
var opponent_health_points = 0

var last_game_result = ""

var game_controller
var choice_UI
var fortune_teller

var floor_name = "tavern" #start floor, set to tavern to begin at start of game
var encounter_count = 0 #start level, set to 1 to begin at start of floor, 0 to start at test room
var dialogue_type = ""

func _ready():
	allow_choices()
	choice_UI.change_choices_visibility(true)
	
	$IDCard.initialise_id_card("Player", player_sprite, player_chips, player_hitpoints, player_max_hitpoints)

func allow_choices():
	choice_UI = load("res://ChoiceUI.tscn").instance()
	choice_UI.connect("starting_suit_chosen", self, "_on_ChoiceUI_starting_suit_chosen")
	choice_UI.connect("reward_card_chosen", self, "_on_ChoiceUI_reward_card_chosen")
	choice_UI.connect("shop_card_chosen", self, "_on_ChoiceUI_shop_card_chosen")
	choice_UI.connect("test_room_finished", self, "_on_ChoiceUI_test_room_finished")
	add_child(choice_UI)

func start_a_game():
	$IDCard.visible = true
	$IDCard.initialise_id_card("Player", player_sprite, player_chips, player_hitpoints, player_max_hitpoints)
	
	var encounter_key = get_encounter_key()
	var encounter_type = $EncounterList.encounter_dictionary[encounter_key].type
	
	if encounter_type == "opponent":
		$IDCard.visible = false
		
		opponent_sprite = $EncounterList.encounter_dictionary[encounter_key].sprite
		opponent_health_points = $EncounterList.encounter_dictionary[encounter_key].healthpoints
		opponent_deck = $EncounterList.encounter_dictionary[encounter_key].deck
		for n in opponent_deck:
			opponent_x_values.append(0)
		
		game_controller = load("res://GameController.tscn").instance()
		game_controller.connect("game_over", self, "on_GameController_game_over")
		game_controller.get_node("HitButton").connect("mouse_entered", $Cursor, "on_HitButton_mouse_entered")
		game_controller.get_node("HitButton").connect("mouse_exited", $Cursor, "on_HitButton_mouse_exited")
		game_controller.get_node("StayButton").connect("mouse_entered", $Cursor, "on_StayButton_mouse_entered")
		game_controller.get_node("StayButton").connect("mouse_exited", $Cursor, "on_StayButton_mouse_exited")
		add_child(game_controller)
		
		game_controller.get_node("Player").get_node("IDCard").initialise_id_card("Player", player_sprite, player_chips, player_hitpoints, player_max_hitpoints)
		game_controller.get_node("Opponent").get_node("IDCard").initialise_id_card( $EncounterList.encounter_dictionary[encounter_key].name, opponent_sprite, $EncounterList.encounter_dictionary[encounter_key].chip_reward, opponent_health_points, opponent_health_points)
		
		$DialogueManager.set_dialogue_text($EncounterList.encounter_dictionary[encounter_key].start_dialogue)
		dialogue_type = "start"
	
	elif encounter_type == "shop":
		allow_choices()
		choice_UI.show_shop()
		
		$DialogueManager.set_dialogue_text($EncounterList.encounter_dictionary[encounter_key].start_dialogue)
	
	elif encounter_type == "fortune_teller":
		fortune_teller = load("res://FortuneTeller.tscn").instance()
		fortune_teller.connect("tarot_card_chosen", self, "_on_FortuneTeller_tarot_card_chosen")
		add_child(fortune_teller)
		
		$DialogueManager.set_dialogue_text($EncounterList.encounter_dictionary[encounter_key].start_dialogue)
	
	elif encounter_type == "testing_room":
		allow_choices()
		choice_UI.show_testing_room()
		
		$DialogueManager.set_dialogue_text($EncounterList.encounter_dictionary[encounter_key].start_dialogue)
	
	elif encounter_type == "win_screen":
		$DialogueManager.set_dialogue_text("you win!")

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

func _on_ChoiceUI_test_room_finished():
	choice_UI.queue_free()
	encounter_count += 1
	start_a_game()

func _on_FortuneTeller_tarot_card_chosen():
	fortune_teller.queue_free()
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
	if dialogue_type == "start":
		game_controller.transition_to("PlayerPreGameChoice", {})
	elif dialogue_type == "end":
		pass
	dialogue_type = ""

func _on_DialogueManager_dialogue_set():
	pass
	#todo: unsure if this is needed

func on_Card_x_value_changed(card):
	player_x_values[card.index_in_deck] = card.x_value

func set_player_chips(chip_number):
	player_chips = chip_number
	$IDCard.change_chips(chip_number)
