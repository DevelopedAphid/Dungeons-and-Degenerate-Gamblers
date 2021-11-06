extends Node

var chosen_suit

signal player_suit_chosen(suit)

func set_player_chosen_suit(suit):
	chosen_suit = suit
	emit_signal("player_suit_chosen", chosen_suit)
	
