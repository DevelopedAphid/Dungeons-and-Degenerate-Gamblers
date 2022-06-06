extends Node

var card_dictionary = {
	"001": {
		"name": "Ace of Spades",
		"suit": "spades",
		"value": 1,
		"effect": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"002": {
		"name": "Two of Spades",
		"suit": "spades",
		"value": 2,
		"effect": false
	},
	"003": {
		"name": "Three of Spades",
		"suit": "spades",
		"value": 3,
		"effect": false
	},
	"004": {
		"name": "Four of Spades",
		"suit": "spades",
		"value": 4,
		"effect": false
	},
	"005": {
		"name": "Five of Spades",
		"suit": "spades",
		"value": 5,
		"effect": false
	},
	"006": {
		"name": "Six of Spades",
		"suit": "spades",
		"value": 6,
		"effect": false
	},
	"007": {
		"name": "Seven of Spades",
		"suit": "spades",
		"value": 7,
		"effect": false
	},
	"008": {
		"name": "Eight of Spades",
		"suit": "spades",
		"value": 8,
		"effect": false
	},
	"009": {
		"name": "Nine of Spades",
		"suit": "spades",
		"value": 9,
		"effect": false
	},
	"010": {
		"name": "Ten of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false
	},
	"011": {
		"name": "Jack of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false
	},
	"012": {
		"name": "Queen of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false
	},
	"013": {
		"name": "King of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false
	},
	"014": {
		"name": "Ace of Clubs",
		"suit": "clubs",
		"value": 1,
		"effect": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"015": {
		"name": "Two of Clubs",
		"suit": "clubs",
		"value": 2,
		"effect": false
	},
	"016": {
		"name": "Three of Clubs",
		"suit": "clubs",
		"value": 3,
		"effect": false
	},
	"017": {
		"name": "Four of Clubs",
		"suit": "clubs",
		"value": 4,
		"effect": false
	},
	"018": {
		"name": "Five of Clubs",
		"suit": "clubs",
		"value": 5,
		"effect": false
	},
	"019": {
		"name": "Six of Clubs",
		"suit": "clubs",
		"value": 6,
		"effect": false
	},
	"020": {
		"name": "Seven of Clubs",
		"suit": "clubs",
		"value": 7,
		"effect": false
	},
	"021": {
		"name": "Eight of Clubs",
		"suit": "clubs",
		"value": 8,
		"effect": false
	},
	"022": {
		"name": "Nine of Clubs",
		"suit": "clubs",
		"value": 9,
		"effect": false
	},
	"023": {
		"name": "Ten of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false
	},
	"024": {
		"name": "Jack of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false
	},
	"025": {
		"name": "Queen of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false
	},
	"026": {
		"name": "King of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false
	},
	"027": {
		"name": "Ace of Diamonds",
		"suit": "diamonds",
		"value": 1,
		"effect": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"028": {
		"name": "Two of Diamonds",
		"suit": "diamonds",
		"value": 2,
		"effect": false
	},
	"029": {
		"name": "Three of Diamonds",
		"suit": "diamonds",
		"value": 3,
		"effect": false
	},
	"030": {
		"name": "Four of Diamonds",
		"suit": "diamonds",
		"value": 4,
		"effect": false
	},
	"031": {
		"name": "Five of Diamonds",
		"suit": "diamonds",
		"value": 5,
		"effect": false
	},
	"032": {
		"name": "Six of Diamonds",
		"suit": "diamonds",
		"value": 6,
		"effect": false
	},
	"033": {
		"name": "Seven of Diamonds",
		"suit": "diamonds",
		"value": 7,
		"effect": false
	},
	"034": {
		"name": "Eight of Diamonds",
		"suit": "diamonds",
		"value": 8,
		"effect": false
	},
	"035": {
		"name": "Nine of Diamonds",
		"suit": "diamonds",
		"value": 9,
		"effect": false
	},
	"036": {
		"name": "Ten of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false
	},
	"037": {
		"name": "Jack of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false
	},
	"038": {
		"name": "Queen of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false
	},
	"039": {
		"name": "King of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false
	},
	"040": {
		"name": "Ace of Hearts",
		"suit": "hearts",
		"value": 1,
		"effect": true,
		"description": "When played, choose value of either 1 or 11"
	},
	"041": {
		"name": "Two of Hearts",
		"suit": "hearts",
		"value": 2,
		"effect": false
	},
	"042": {
		"name": "Three of Hearts",
		"suit": "hearts",
		"value": 3,
		"effect": false
	},
	"043": {
		"name": "Four of Hearts",
		"suit": "hearts",
		"value": 4,
		"effect": false
	},
	"044": {
		"name": "Five of Hearts",
		"suit": "hearts",
		"value": 5,
		"effect": false
	},
	"045": {
		"name": "Six of Hearts",
		"suit": "hearts",
		"value": 6,
		"effect": false
	},
	"046": {
		"name": "Seven of Hearts",
		"suit": "hearts",
		"value": 7,
		"effect": false
	},
	"047": {
		"name": "Eight of Hearts",
		"suit": "hearts",
		"value": 8,
		"effect": false
	},
	"048": {
		"name": "Nine of Hearts",
		"suit": "hearts",
		"value": 9,
		"effect": false
	},
	"049": {
		"name": "Ten of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false
	},
	"050": {
		"name": "Jack of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false
	},
	"051": {
		"name": "Queen of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false
	},
	"052": {
		"name": "King of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false
	},
	"053": {
		"name": "Eleven of Spades",
		"suit": "spades",
		"value": 11,
		"effect": false
	},
	"054": {
		"name": "Twelve of Spades",
		"suit": "spades",
		"value": 12,
		"effect": false
	},
	"055": {
		"name": "Thirteen of Spades",
		"suit": "spades",
		"value": 13,
		"effect": false
	},
	"056": {
		"name": "Eleven of Clubs",
		"suit": "clubs",
		"value": 11,
		"effect": false
	},
	"057": {
		"name": "Twelve of Clubs",
		"suit": "clubs",
		"value": 12,
		"effect": false
	},
	"058": {
		"name": "Thirteen of Clubs",
		"suit": "clubs",
		"value": 13,
		"effect": false
	},
	"059": {
		"name": "Eleven of Diamonds",
		"suit": "diamonds",
		"value": 11,
		"effect": false
	},
	"060": {
		"name": "Twelve of Diamonds",
		"suit": "diamonds",
		"value": 12,
		"effect": false
	},
	"061": {
		"name": "Thirteen of Diamonds",
		"suit": "diamonds",
		"value": 13,
		"effect": false
	},
	"062": {
		"name": "Eleven of Hearts",
		"suit": "hearts",
		"value": 11,
		"effect": false
	},
	"063": {
		"name": "Twelve of Hearts",
		"suit": "hearts",
		"value": 12,
		"effect": false
	},
	"064": {
		"name": "Thirteen of Hearts",
		"suit": "hearts",
		"value": 13,
		"effect": false
	},
	"065": {
		"name": "Twenty One of Spades",
		"suit": "spades",
		"value": 21,
		"effect": false
	},
	"066": {
		"name": "Twenty One of Clubs",
		"suit": "clubs",
		"value": 21,
		"effect": false
	},
	"067": {
		"name": "Twenty One of Diamonds",
		"suit": "diamonds",
		"value": 21,
		"effect": false
	},
	"068": {
		"name": "Twenty One of Hearts",
		"suit": "hearts",
		"value": 21,
		"effect": false
	},
	"069": {
		"name": "Joker",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "When played, choose a card from your discard pile to copy the value from"
	},
	"070": {
		"name": "Birthday Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "When played, increase this card's value by 1"
	},
	"071": {
		"name": "Magic Trick Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "When played, choose to change this card to either Queen of Hearts or 7 of Clubs"
	},
	"072": {
		"name": "Red Joker",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "When played, choose a card from your play pile to copy the effect and value from"
	},
	"073": {
		"name": "Double Back Card",
		"suit": "special",
		"value": 0,
		"effect": false,
		"description": ""
	},
	"074": {
		"name": "Rules Card",
		"suit": "special",
		"value": 0,
		"effect": false, #Todo
		"description": ""
	},
	"075": {
		"name": "Jack of All Trades",
		"suit": "all_suits_at_once",
		"value": 10,
		"effect": false,
		"description": "Has the blackjack effect of all four suits at once"
	},
		"076": {
		"name": "Get Well Soon Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"burns": true,
		"description": "Heals both players by 10, then burns"
	},
		"077": {
		"name": "+2 Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "Your opponent immediately hits twice"
	},
		"078": {
		"name": "Reverse Card",
		"suit": "special",
		"value": 0,
		"effect": true,
		"description": "Swap currently played cards with your opponent"
	},
		"079": {
		"name": "Negative Ace of Spades",
		"suit": "negative_spades",
		"value": -1,
		"effect": true,
		"description": "When played, choose value of either -1 or -11"
	},
		"080": {
		"name": "Negative Two of Spades",
		"suit": "negative_spades",
		"value": -2,
		"effect": false
	},
		"081": {
		"name": "Negative Three of Spades",
		"suit": "negative_spades",
		"value": -3,
		"effect": false
	},
		"082": {
		"name": "Negative Four of Spades",
		"suit": "negative_spades",
		"value": -4,
		"effect": false
	},
		"083": {
		"name": "Negative Five of Spades",
		"suit": "negative_spades",
		"value": -5,
		"effect": false
	},
		"084": {
		"name": "Negative Six of Spades",
		"suit": "negative_spades",
		"value": -6,
		"effect": false
	},
		"085": {
		"name": "Negative Seven of Spades",
		"suit": "negative_spades",
		"value": -7,
		"effect": false
	},
		"086": {
		"name": "Negative Eight of Spades",
		"suit": "negative_spades",
		"value": -8,
		"effect": false
	},
		"087": {
		"name": "Negative Nine of Spades",
		"suit": "negative_spades",
		"value": -9,
		"effect": false
	},
		"088": {
		"name": "Negative Ten of Spades",
		"suit": "negative_spades",
		"value": -10,
		"effect": false
	},
		"089": {
		"name": "Negative Eleven of Spades",
		"suit": "negative_spades",
		"value": -11,
		"effect": false,
		"description": "When played, choose value of either -1 or -11"
	},
		"090": {
		"name": "Negative Ace of Clubs",
		"suit": "negative_clubs",
		"value": -1,
		"effect": true
	},
		"091": {
		"name": "Negative Two of Clubs",
		"suit": "negative_clubs",
		"value": -2,
		"effect": false
	},
		"092": {
		"name": "Negative Three of Clubs",
		"suit": "negative_clubs",
		"value": -3,
		"effect": false
	},
		"093": {
		"name": "Negative Four of Clubs",
		"suit": "negative_clubs",
		"value": -4,
		"effect": false
	},
		"094": {
		"name": "Negative Five of Clubs",
		"suit": "negative_clubs",
		"value": -5,
		"effect": false
	},
		"095": {
		"name": "Negative Six of Clubs",
		"suit": "negative_clubs",
		"value": -6,
		"effect": false
	},
		"096": {
		"name": "Negative Seven of Clubs",
		"suit": "negative_clubs",
		"value": -7,
		"effect": false
	},
		"097": {
		"name": "Negative Eight of Clubs",
		"suit": "negative_clubs",
		"value": -8,
		"effect": false
	},
		"098": {
		"name": "Negative Nine of Clubs",
		"suit": "negative_clubs",
		"value": -9,
		"effect": false
	},
		"099": {
		"name": "Negative Ten of Clubs",
		"suit": "negative_clubs",
		"value": -10,
		"effect": false
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
		"description": "When played, choose value of either -1 or -11"
	},
		"102": {
		"name": "Negative Two of Diamonds",
		"suit": "negative_diamonds",
		"value": -2,
		"effect": false
	},
		"103": {
		"name": "Negative Three of Diamonds",
		"suit": "negative_diamonds",
		"value": -3,
		"effect": false
	},
		"104": {
		"name": "Negative Four of Diamonds",
		"suit": "negative_diamonds",
		"value": -4,
		"effect": false
	},
		"105": {
		"name": "Negative Five of Diamonds",
		"suit": "negative_diamonds",
		"value": -5,
		"effect": false
	},
		"106": {
		"name": "Negative Six of Diamonds",
		"suit": "negative_diamonds",
		"value": -6,
		"effect": false
	},
		"107": {
		"name": "Negative Seven of Diamonds",
		"suit": "negative_diamonds",
		"value": -7,
		"effect": false
	},
		"108": {
		"name": "Negative Eight of Diamonds",
		"suit": "negative_diamonds",
		"value": -8,
		"effect": false
	},
		"109": {
		"name": "Negative Nine of Diamonds",
		"suit": "negative_diamonds",
		"value": -9,
		"effect": false
	},
		"110": {
		"name": "Negative Ten of Diamonds",
		"suit": "negative_diamonds",
		"value": -10,
		"effect": false
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
		"description": "When played, choose value of either -1 or -11"
	},
		"113": {
		"name": "Negative Two of Hearts",
		"suit": "negative_hearts",
		"value": -2,
		"effect": false
	},
		"114": {
		"name": "Negative Three of Hearts",
		"suit": "negative_hearts",
		"value": -3,
		"effect": false
	},
		"115": {
		"name": "Negative Four of Hearts",
		"suit": "negative_hearts",
		"value": -4,
		"effect": false
	},
		"116": {
		"name": "Negative Five of Hearts",
		"suit": "negative_hearts",
		"value": -5,
		"effect": false
	},
		"117": {
		"name": "Negative Six of Hearts",
		"suit": "negative_hearts",
		"value": -6,
		"effect": false
	},
		"118": {
		"name": "Negative Seven of Hearts",
		"suit": "negative_hearts",
		"value": -7,
		"effect": false
	},
		"119": {
		"name": "Negative Eight of Hearts",
		"suit": "negative_hearts",
		"value": -8,
		"effect": false
	},
		"120": {
		"name": "Negative Nine of Hearts",
		"suit": "negative_hearts",
		"value": -9,
		"effect": false
	},
		"121": {
		"name": "Negative Ten of Hearts",
		"suit": "negative_hearts",
		"value": -10,
		"effect": false
	},
		"122": {
		"name": "Negative Eleven of Hearts",
		"suit": "negative_hearts",
		"value": -11,
		"effect": false
	}
}
