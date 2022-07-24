extends Node2D

onready var starting_suit_cards = $StartingSuitChoice.get_children()

onready var macro_controller = get_parent()

signal starting_suit_chosen
signal reward_card_chosen
signal shop_card_chosen
signal test_room_finished

var shop_card_price = 100

func _ready():
	randomize()
	change_choices_visibility(false)
	
	for card in starting_suit_cards:
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
		
		card.set_card_name(card.card_suit)
		card.card_description = "Choose the " + card.card_suit + " suit as your starter deck. "
		var current_description = card.card_description
		match card.card_suit:
			"spades":
				card.card_description = current_description + "On blackjack, spades grant you a shield for the next round."
			"clubs":
				card.card_description = current_description + "On blackjack, clubs deal double damage."
			"diamonds":
				card.card_description = current_description + "On blackjack, diamonds grant you chips."
			"hearts":
				card.card_description = current_description + "On blackjack, hearts heal you."

func change_choices_visibility(visibility: bool):
	$StartingSuitChoice.visible = visibility

func present_rewards():
	var reward_array = []
	for i in 3:
		reward_array.append(int(CardList.get_random_reward_card_id()))
	
	$RewardCardChoice/Reward1.set_card_id(reward_array[0])
	$RewardCardChoice/Reward2.set_card_id(reward_array[1])
	$RewardCardChoice/Reward3.set_card_id(reward_array[2])
	
	var reward_cards = $RewardCardChoice.get_children()
	for card in reward_cards:
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
	
	$RewardCardChoice.visible = true

func show_shop():
	var shop_array = []
	for i in 8:
		shop_array.append(int(CardList.get_random_reward_card_id()))
	
	var shop_cards = $Shop/ShopChoice.get_children()
	var i = 0
	for card in shop_cards:
		card.set_card_id(shop_array[i])
		i += 1
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
	
	$Shop.visible = true

func show_testing_room():
	var x_pos = 0
	var y_pos = 0
	for card_id in CardList.card_dictionary:
		var card = load("res://Card.tscn").instance()
		$TestChoice.add_child(card)
		card.set_card_id(card_id)
		if(x_pos > 440):
			y_pos += 90
			x_pos = 0
		card.position = Vector2(x_pos, y_pos)
		x_pos += 8 #card spacing

		
		card.add_to_group("choices")
		
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
	
	$TestChoice.visible = true

func _on_Card_clicked(card_choice):
	if card_choice.get_parent().name == "RewardCardChoice":
		macro_controller.player_deck.append(card_choice.card_id)
		macro_controller.player_x_values.append(0)
		$RewardCardChoice.visible = false
		emit_signal("reward_card_chosen")
	elif card_choice.get_parent().name == "StartingSuitChoice":
		if card_choice.card_id == "001":
			macro_controller.chosen_suit = "spades"
			macro_controller.player_deck = [
				"001", "002", "003", "004", "005", "006", 
				"007", "008", "009", "010", "011", "012", "013"]
		if card_choice.card_id == "014":
			macro_controller.chosen_suit = "clubs"
			macro_controller.player_deck = [
				"014", "015", "016", "017", "018", "019", 
				"020", "021", "022", "023", "024", "025", "026"]
		if card_choice.card_id == "027":
			macro_controller.chosen_suit = "diamonds"
			macro_controller.player_deck = [
				"027", "028", "029", "030", "031", "032", 
				"033", "034", "035", "036", "037", "038", "039"]
		if card_choice.card_id == "040":
			macro_controller.chosen_suit = "hearts"
			macro_controller.player_deck = [
				"040", "041", "042", "043", "044", "045", 
				"046", "047", "048", "049", "050", "051", "052"]
		for n in macro_controller.player_deck:
			macro_controller.player_x_values.append(0)
		
		emit_signal("starting_suit_chosen")
	elif card_choice.get_parent().name == "ShopChoice":
		if macro_controller.player_chips >= shop_card_price:
			macro_controller.player_deck.append(card_choice.card_id)
			macro_controller.player_x_values.append(0)
			macro_controller.set_player_chips(macro_controller.player_chips - shop_card_price)
			card_choice.visible = false
	elif card_choice.get_parent().name == "TestChoice":
		macro_controller.player_deck.append(card_choice.card_id)
		macro_controller.player_x_values.append(0)
	
	change_choices_visibility(false)

func _on_ShopFinishedButton_pressed():
	$Shop.visible = false
	emit_signal("shop_card_chosen")

func _on_TestFinishedButton_pressed():
	$TestChoice.visible = false
	emit_signal("test_room_finished")
