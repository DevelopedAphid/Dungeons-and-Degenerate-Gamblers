extends Node2D

onready var cards = $StartingSuitChoice.get_children()

func _ready():
	change_choices_visibilty(false)
	
	for card in cards:
		card.add_to_group("choices")
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Card_clicked", [card])
		
		card.set_card_name(card.card_suit)
		card.card_description = "Choose the " + card.card_suit + " suit as your starter deck"

func change_choices_visibilty(visibility: bool):
	$StartingSuitChoice.visible = visibility

func _on_Card_clicked(card_choice):
	if card_choice.card_id == "001":
		PlayerSettings.chosen_suit = "spades"
		PlayerSettings.player_deck = [
			"001", "002", "003", "004", "005", "006", 
			"007", "008", "009", "010", "011", "012", "013", 
			"069", "070", "071", "072" ]
	if card_choice.card_id == "014":
		PlayerSettings.chosen_suit = "clubs"
		PlayerSettings.player_deck = [
			"014", "015", "016", "017", "018", "019", 
			"020", "021", "022", "023", "024", "025", "026", 
			"069", "070", "071", "072" ]
	if card_choice.card_id == "027":
		PlayerSettings.chosen_suit = "diamonds"
		PlayerSettings.player_deck = [
			"027", "028", "029", "030", "031", "032", 
			"033", "034", "035", "036", "037", "038", "039", 
			"069", "070", "071", "072" ]
	if card_choice.card_id == "040":
		PlayerSettings.chosen_suit = "hearts"
		PlayerSettings.player_deck = [
			"040", "041", "042", "043", "044", "045", 
			"046", "047", "048", "049", "050", "051", "052", 
			"069", "070", "071", "072" ]
	
	change_choices_visibilty(false)
