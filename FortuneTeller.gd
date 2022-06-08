extends Node2D

signal tarot_card_chosen

onready var macro_controller = get_parent()
var card1_flipped = false
var card2_flipped = false
var card3_flipped = false

func _ready():
	connect_to_card_backs()

func connect_to_card_backs():
	for card in $Cards.get_children():
		card.set_card_id(card.card_id)
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		card.connect("card_clicked", self, "_on_CardBack_clicked", [card])

func _on_CardBack_clicked(card):
	if card1_flipped && card2_flipped && card3_flipped: #if all flipped then add card to deck and move on
		macro_controller.player_deck.append(card.card_id)
		emit_signal("tarot_card_chosen")
		print("all flipped")
	
	var index = card.get_index()
	match index: #check if card already flipped and skip if it is, otherwise mark it as flipped
		0:
			if card1_flipped:
				return
			else: 
				card1_flipped = true
		1:
			if card2_flipped:
				return
			else:
				card2_flipped = true
		2:
			if card3_flipped:
				return
			else:
				card3_flipped = true
	card.set_card_id(get_random_card_id())

func get_random_card_id() -> int:
	return int(rand_range(1, CardList.card_dictionary.size()))
