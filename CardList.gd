extends Node

var reward_cards = []
var tarot_cards = []

func _ready():
	for card in card_dictionary:
		if card_dictionary[card].has("reward"):
			if card_dictionary[card].reward == true:
				reward_cards.append(card)
		if card_dictionary[card].has("tarot"):
			if card_dictionary[card].tarot == true:
				tarot_cards.append(card)

func get_random_reward_card_id() -> String:
	return str(reward_cards[round(rand_range(0, reward_cards.size() - 1))])

func get_random_tarot_card_id() -> String:
	return str(tarot_cards[round(rand_range(0, tarot_cards.size() - 1))])

var card_dictionary = {
	"001": {
		"name": "Ace of Spades",
		"suit": "spades",
		"value": 1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"002": {
		"name": "Two of Spades",
		"suit": "spades",
		"value": 2,
		"effect": false,
		"reward": true
	},
	"003": {
		"name": "Three of Spades",
		"suit": "spades",
		"value": 3,
		"effect": false,
		"reward": true
	},
	"004": {
		"name": "Four of Spades",
		"suit": "spades",
		"value": 4,
		"effect": false,
		"reward": true
	},
	"005": {
		"name": "Five of Spades",
		"suit": "spades",
		"value": 5,
		"effect": false,
		"reward": true
	},
	"006": {
		"name": "Six of Spades",
		"suit": "spades",
		"value": 6,
		"effect": false,
		"reward": true
	},
	"007": {
		"name": "Seven of Spades",
		"suit": "spades",
		"value": 7,
		"effect": false,
		"reward": true
	},
	"008": {
		"name": "Eight of Spades",
		"suit": "spades",
		"value": 8,
		"effect": false,
		"reward": true
	},
	"009": {
		"name": "Nine of Spades",
		"suit": "spades",
		"value": 9,
		"effect": false,
		"reward": true
	},
	"010": {
		"name": "Ten of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"011": {
		"name": "Jack of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"012": {
		"name": "Queen of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"013": {
		"name": "King of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"014": {
		"name": "Ace of Clubs",
		"suit": "clubs",
		"value": 1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"015": {
		"name": "Two of Clubs",
		"suit": "clubs",
		"value": 2,
		"effect": false,
		"reward": true
	},
	"016": {
		"name": "Three of Clubs",
		"suit": "clubs",
		"value": 3,
		"effect": false,
		"reward": true
	},
	"017": {
		"name": "Four of Clubs",
		"suit": "clubs",
		"value": 4,
		"effect": false,
		"reward": true
	},
	"018": {
		"name": "Five of Clubs",
		"suit": "clubs",
		"value": 5,
		"effect": false,
		"reward": true
	},
	"019": {
		"name": "Six of Clubs",
		"suit": "clubs",
		"value": 6,
		"effect": false,
		"reward": true
	},
	"020": {
		"name": "Seven of Clubs",
		"suit": "clubs",
		"value": 7,
		"effect": false,
		"reward": true
	},
	"021": {
		"name": "Eight of Clubs",
		"suit": "clubs",
		"value": 8,
		"effect": false,
		"reward": true
	},
	"022": {
		"name": "Nine of Clubs",
		"suit": "clubs",
		"value": 9,
		"effect": false,
		"reward": true
	},
	"023": {
		"name": "Ten of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"024": {
		"name": "Jack of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"025": {
		"name": "Queen of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"026": {
		"name": "King of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"027": {
		"name": "Ace of Diamonds",
		"suit": "diamonds",
		"value": 1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"028": {
		"name": "Two of Diamonds",
		"suit": "diamonds",
		"value": 2,
		"effect": false,
		"reward": true
	},
	"029": {
		"name": "Three of Diamonds",
		"suit": "diamonds",
		"value": 3,
		"effect": false,
		"reward": true
	},
	"030": {
		"name": "Four of Diamonds",
		"suit": "diamonds",
		"value": 4,
		"effect": false,
		"reward": true
	},
	"031": {
		"name": "Five of Diamonds",
		"suit": "diamonds",
		"value": 5,
		"effect": false,
		"reward": true
	},
	"032": {
		"name": "Six of Diamonds",
		"suit": "diamonds",
		"value": 6,
		"effect": false,
		"reward": true
	},
	"033": {
		"name": "Seven of Diamonds",
		"suit": "diamonds",
		"value": 7,
		"effect": false,
		"reward": true
	},
	"034": {
		"name": "Eight of Diamonds",
		"suit": "diamonds",
		"value": 8,
		"effect": false,
		"reward": true
	},
	"035": {
		"name": "Nine of Diamonds",
		"suit": "diamonds",
		"value": 9,
		"effect": false,
		"reward": true
	},
	"036": {
		"name": "Ten of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"037": {
		"name": "Jack of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"038": {
		"name": "Queen of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"039": {
		"name": "King of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"040": {
		"name": "Ace of Hearts",
		"suit": "hearts",
		"value": 1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"041": {
		"name": "Two of Hearts",
		"suit": "hearts",
		"value": 2,
		"effect": false,
		"reward": true
	},
	"042": {
		"name": "Three of Hearts",
		"suit": "hearts",
		"value": 3,
		"effect": false,
		"reward": true
	},
	"043": {
		"name": "Four of Hearts",
		"suit": "hearts",
		"value": 4,
		"effect": false,
		"reward": true
	},
	"044": {
		"name": "Five of Hearts",
		"suit": "hearts",
		"value": 5,
		"effect": false,
		"reward": true
	},
	"045": {
		"name": "Six of Hearts",
		"suit": "hearts",
		"value": 6,
		"effect": false,
		"reward": true
	},
	"046": {
		"name": "Seven of Hearts",
		"suit": "hearts",
		"value": 7,
		"effect": false,
		"reward": true
	},
	"047": {
		"name": "Eight of Hearts",
		"suit": "hearts",
		"value": 8,
		"effect": false,
		"reward": true
	},
	"048": {
		"name": "Nine of Hearts",
		"suit": "hearts",
		"value": 9,
		"effect": false,
		"reward": true
	},
	"049": {
		"name": "Ten of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"050": {
		"name": "Jack of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"051": {
		"name": "Queen of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"052": {
		"name": "King of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false,
		"reward": true
	},
	"053": {
		"name": "Eleven of Spades",
		"suit": "spades",
		"value": 11,
		"effect": false,
		"reward": true
	},
	"054": {
		"name": "Twelve of Spades",
		"suit": "spades",
		"value": 12,
		"effect": false,
		"reward": true
	},
	"055": {
		"name": "Thirteen of Spades",
		"suit": "spades",
		"value": 13,
		"effect": false,
		"reward": true
	},
	"056": {
		"name": "Eleven of Clubs",
		"suit": "clubs",
		"value": 11,
		"effect": false,
		"reward": true
	},
	"057": {
		"name": "Twelve of Clubs",
		"suit": "clubs",
		"value": 12,
		"effect": false,
		"reward": true
	},
	"058": {
		"name": "Thirteen of Clubs",
		"suit": "clubs",
		"value": 13,
		"effect": false,
		"reward": true
	},
	"059": {
		"name": "Eleven of Diamonds",
		"suit": "diamonds",
		"value": 11,
		"effect": false,
		"reward": true
	},
	"060": {
		"name": "Twelve of Diamonds",
		"suit": "diamonds",
		"value": 12,
		"effect": false,
		"reward": true
	},
	"061": {
		"name": "Thirteen of Diamonds",
		"suit": "diamonds",
		"value": 13,
		"effect": false,
		"reward": true
	},
	"062": {
		"name": "Eleven of Hearts",
		"suit": "hearts",
		"value": 11,
		"effect": false,
		"reward": true
	},
	"063": {
		"name": "Twelve of Hearts",
		"suit": "hearts",
		"value": 12,
		"effect": false,
		"reward": true
	},
	"064": {
		"name": "Thirteen of Hearts",
		"suit": "hearts",
		"value": 13,
		"effect": false,
		"reward": true
	},
	"065": {
		"name": "Twenty One of Spades",
		"suit": "spades",
		"value": 21,
		"effect": false,
		"reward": true
	},
	"066": {
		"name": "Twenty One of Clubs",
		"suit": "clubs",
		"value": 21,
		"effect": false,
		"reward": true
	},
	"067": {
		"name": "Twenty One of Diamonds",
		"suit": "diamonds",
		"value": 21,
		"effect": false,
		"reward": true
	},
	"068": {
		"name": "Twenty One of Hearts",
		"suit": "hearts",
		"value": 21,
		"effect": false,
		"reward": true
	},
	"069": {
		"name": "Joker",
		"suit": "special",
		"value": 0,
		"effect": true,
		"reward": true,
		"description": "When played, choose a card from your discard pile to copy the value from"
	},
	"070": {
		"name": "Birthday Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"reward": true,
		"description": "When played, increase this card's value by 1"
	},
	"071": {
		"name": "Magic Trick Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"reward": true,
		"description": "When played, choose to change this card to either Queen of Hearts or 7 of Clubs"
	},
	"072": {
		"name": "Red Joker",
		"suit": "special",
		"value": 0,
		"effect": true,
		"reward": true,
		"description": "When played, choose a card from your play pile to copy the effect and value from"
	},
	"073": {
		"name": "Double Back Card",
		"suit": "special",
		"value": 0,
		"effect": false,
		"reward": true,
		"description": ""
	},
	"074": {
		"name": "Rules Card",
		"suit": "special",
		"value": 0,
		"effect": false, #Todo
		"reward": true,
		"description": ""
	},
	"075": {
		"name": "Jack of All Trades",
		"suit": "all_suits_at_once",
		"value": 10,
		"effect": false,
		"reward": true,
		"description": "Has the blackjack effect of all four suits at once"
	},
		"076": {
		"name": "Get Well Soon Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"burns": true,
		"reward": true,
		"description": "Heals the player by 10. Burns"
	},
		"077": {
		"name": "+2 Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"reward": true,
		"description": "Your opponent immediately hits twice"
	},
		"078": {
		"name": "Reverse Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"reward": true,
		"description": "Swap currently played cards with your opponent"
	},
		"079": {
		"name": "Negative Ace of Spades",
		"suit": "negative_spades",
		"value": -1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either -1 or -11"
	},
		"080": {
		"name": "Negative Two of Spades",
		"suit": "negative_spades",
		"value": -2,
		"effect": false,
		"reward": true
	},
		"081": {
		"name": "Negative Three of Spades",
		"suit": "negative_spades",
		"value": -3,
		"effect": false,
		"reward": true
	},
		"082": {
		"name": "Negative Four of Spades",
		"suit": "negative_spades",
		"value": -4,
		"effect": false,
		"reward": true
	},
		"083": {
		"name": "Negative Five of Spades",
		"suit": "negative_spades",
		"value": -5,
		"effect": false,
		"reward": true
	},
		"084": {
		"name": "Negative Six of Spades",
		"suit": "negative_spades",
		"value": -6,
		"effect": false,
		"reward": true
	},
		"085": {
		"name": "Negative Seven of Spades",
		"suit": "negative_spades",
		"value": -7,
		"effect": false,
		"reward": true
	},
		"086": {
		"name": "Negative Eight of Spades",
		"suit": "negative_spades",
		"value": -8,
		"effect": false,
		"reward": true
	},
		"087": {
		"name": "Negative Nine of Spades",
		"suit": "negative_spades",
		"value": -9,
		"effect": false,
		"reward": true
	},
		"088": {
		"name": "Negative Ten of Spades",
		"suit": "negative_spades",
		"value": -10,
		"effect": false,
		"reward": true
	},
		"089": {
		"name": "Negative Eleven of Spades",
		"suit": "negative_spades",
		"value": -11,
		"effect": false
	},
		"090": {
		"name": "Negative Ace of Clubs",
		"suit": "negative_clubs",
		"value": -1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either -1 or -11"
	},
		"091": {
		"name": "Negative Two of Clubs",
		"suit": "negative_clubs",
		"value": -2,
		"effect": false,
		"reward": true
	},
		"092": {
		"name": "Negative Three of Clubs",
		"suit": "negative_clubs",
		"value": -3,
		"effect": false,
		"reward": true
	},
		"093": {
		"name": "Negative Four of Clubs",
		"suit": "negative_clubs",
		"value": -4,
		"effect": false,
		"reward": true
	},
		"094": {
		"name": "Negative Five of Clubs",
		"suit": "negative_clubs",
		"value": -5,
		"effect": false,
		"reward": true
	},
		"095": {
		"name": "Negative Six of Clubs",
		"suit": "negative_clubs",
		"value": -6,
		"effect": false,
		"reward": true
	},
		"096": {
		"name": "Negative Seven of Clubs",
		"suit": "negative_clubs",
		"value": -7,
		"effect": false,
		"reward": true
	},
		"097": {
		"name": "Negative Eight of Clubs",
		"suit": "negative_clubs",
		"value": -8,
		"effect": false,
		"reward": true
	},
		"098": {
		"name": "Negative Nine of Clubs",
		"suit": "negative_clubs",
		"value": -9,
		"effect": false,
		"reward": true
	},
		"099": {
		"name": "Negative Ten of Clubs",
		"suit": "negative_clubs",
		"value": -10,
		"effect": false,
		"reward": true
	},
		"100": {
		"name": "Negative Eleven of Clubs",
		"suit": "negative_clubs",
		"value": -11,
		"effect": false
	},
		"101": {
		"name": "Negative Ace of Diamonds",
		"suit": "negative_diamonds",
		"value": -1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either -1 or -11"
	},
		"102": {
		"name": "Negative Two of Diamonds",
		"suit": "negative_diamonds",
		"value": -2,
		"effect": false,
		"reward": true
	},
		"103": {
		"name": "Negative Three of Diamonds",
		"suit": "negative_diamonds",
		"value": -3,
		"effect": false,
		"reward": true
	},
		"104": {
		"name": "Negative Four of Diamonds",
		"suit": "negative_diamonds",
		"value": -4,
		"effect": false,
		"reward": true
	},
		"105": {
		"name": "Negative Five of Diamonds",
		"suit": "negative_diamonds",
		"value": -5,
		"effect": false,
		"reward": true
	},
		"106": {
		"name": "Negative Six of Diamonds",
		"suit": "negative_diamonds",
		"value": -6,
		"effect": false,
		"reward": true
	},
		"107": {
		"name": "Negative Seven of Diamonds",
		"suit": "negative_diamonds",
		"value": -7,
		"effect": false,
		"reward": true
	},
		"108": {
		"name": "Negative Eight of Diamonds",
		"suit": "negative_diamonds",
		"value": -8,
		"effect": false,
		"reward": true
	},
		"109": {
		"name": "Negative Nine of Diamonds",
		"suit": "negative_diamonds",
		"value": -9,
		"effect": false,
		"reward": true
	},
		"110": {
		"name": "Negative Ten of Diamonds",
		"suit": "negative_diamonds",
		"value": -10,
		"effect": false,
		"reward": true
	},
		"111": {
		"name": "Negative Eleven of Diamonds",
		"suit": "negative_diamonds",
		"value": -11,
		"effect": false
	},
		"112": {
		"name": "Negative Ace of Hearts",
		"suit": "negative_hearts",
		"value": -1,
		"effect": true,
		"reward": true,
		"description": "When played, choose value of either -1 or -11"
	},
		"113": {
		"name": "Negative Two of Hearts",
		"suit": "negative_hearts",
		"value": -2,
		"effect": false,
		"reward": true
	},
		"114": {
		"name": "Negative Three of Hearts",
		"suit": "negative_hearts",
		"value": -3,
		"effect": false,
		"reward": true
	},
		"115": {
		"name": "Negative Four of Hearts",
		"suit": "negative_hearts",
		"value": -4,
		"effect": false,
		"reward": true
	},
		"116": {
		"name": "Negative Five of Hearts",
		"suit": "negative_hearts",
		"value": -5,
		"effect": false,
		"reward": true
	},
		"117": {
		"name": "Negative Six of Hearts",
		"suit": "negative_hearts",
		"value": -6,
		"effect": false,
		"reward": true
	},
		"118": {
		"name": "Negative Seven of Hearts",
		"suit": "negative_hearts",
		"value": -7,
		"effect": false,
		"reward": true
	},
		"119": {
		"name": "Negative Eight of Hearts",
		"suit": "negative_hearts",
		"value": -8,
		"effect": false,
		"reward": true
	},
		"120": {
		"name": "Negative Nine of Hearts",
		"suit": "negative_hearts",
		"value": -9,
		"effect": false,
		"reward": true
	},
		"121": {
		"name": "Negative Ten of Hearts",
		"suit": "negative_hearts",
		"value": -10,
		"effect": false,
		"reward": true
	},
		"122": {
		"name": "Negative Eleven of Hearts",
		"suit": "negative_hearts",
		"value": -11,
		"effect": false
	},
		"123": {
		"name": "I The Magician",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "Adds cards to draw pile: 3x magic trick card, 2x aces, 1x ace up your sleeve. burns"
	},
		"124": {
		"name": "II The High Priestess",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "Reveals the next 3 cards in your draw pile"
	},
		"125": {
		"name": "III The Empress",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"burns": true,
		"description": "locks an 11 of hearts to players play pile. burns"
	},
		"126": {
		"name": "IV The Emporer",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "score over 21 this turn will instead be taken as damage to both players"
	},
		"127": {
		"name": "V The Heirophant",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "score over 21 this turn will instead heal both players"
	},
		"128": {
		"name": "VI The Lovers",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "choose from the following to add to draw pile: valentines card, ace of hearts, another VI The Lovers"
	},
		"129": {
		"name": "VII The Chariot",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"burns": true,
		"description": "opponent cannot hit next round. burns"
	},
		"130": {
		"name": "VIII Justice",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"burns": true,
		"description": "Replaces all of your jacks with jack of all trades. Adds a jack of all trades to draw pile. Burns"
	},
		"131": {
		"name": "IX The Hermit",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"132": {
		"name": "X Wheel of Fortune",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"133": {
		"name": "XI Strength",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "opponent cannot hit again this round"
	},
		"134": {
		"name": "XII The Hanged Man",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"135": {
		"name": "XIII Death",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"136": {
		"name": "XIV Temperance",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"137": {
		"name": "XV The Devil",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"138": {
		"name": "XVI The Tower",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"139": {
		"name": "XVII The Star",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "heal self by 17, do double damage this round win. burns"
	},
		"140": {
		"name": "XVIII The Moon",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"141": {
		"name": "XIX The Sun",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"description": "choose a card in your draw pile to put on top of draw pile"
	},
		"142": {
		"name": "XX Judgment",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true,
		"burns": true,
		"description": "take no damage from the next opponent blackjack. burns"
	},
		"143": {
		"name": "XXI The World",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"144": {
		"name": "0 The Fool",
		"suit": "special",
		"value": 0,
		"effect": true,
		"tarot": true
	},
		"145": {
		"name": "Ace Up Your Sleeve",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "Puts an ace of a random suit up your sleeve to be played later"
	},
		"146": {
		"name": "Valentines Card",
		"suit": "special",
		"value": 14,
		"effect": true,
		"description": "Heals both players by 14"
	}
}
