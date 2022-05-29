extends Node2D

onready var starting_suit_cards = $StartingSuitChoice.get_children()

onready var macro_controller = get_parent()

signal starting_suit_chosen
signal reward_card_chosen

func _ready():
	change_choices_visibility(false)
	
	for card in starting_suit_cards:
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
		
		card.set_card_name(card.card_suit)
		card.card_description = "Choose the " + card.card_suit + " suit as your starter deck"

func change_choices_visibility(visibility: bool):
	$StartingSuitChoice.visible = visibility

func present_rewards():
	var reward_array = []
	for i in 3:
		reward_array.append(int(rand_range(1, CardList.card_dictionary.size())))
	
	$RewardCardChoice/Reward1.set_card_id(reward_array[0])
	$RewardCardChoice/Reward2.set_card_id(reward_array[1])
	$RewardCardChoice/Reward3.set_card_id(reward_array[2])
	
	var reward_cards = $RewardCardChoice.get_children()
	for card in reward_cards:
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
	
	$RewardCardChoice.visible = true

func _on_Card_clicked(card_choice):
	if card_choice.get_parent().name == "RewardCardChoice":
		macro_controller.player_deck.append(card_choice.card_id)
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
		
		var testing_cards = ["069", "070", "071", "072", "076", "077", "078", "118", "119"]
		for n in testing_cards:
			macro_controller.player_deck.append(n)
		
		emit_signal("starting_suit_chosen")
	
	change_choices_visibility(false)
