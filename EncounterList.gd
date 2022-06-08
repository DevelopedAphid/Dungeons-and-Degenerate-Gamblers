extends Node

var encounter_dictionary = {
	"tavern.1": {
		"name": "imp",
		"type": "opponent",
		"sprite": "res://assets/art/characters/imp.png",
		"healthpoints": 10,
		"deck": ["057", "058", "056", "044", "006", "006"],
		"chip_reward": 100,
		"start_dialogue": "well hello buddy",
		"end_dialogue": "how rude buddy"
	},
	"tavern.2": {
		"name": "wizard",
		"type": "opponent",
		"sprite": "res://assets/art/characters/wizard.png",
		"healthpoints": 10,
		"deck": ["057", "058", "056", "044", "006", "006"],
		"chip_reward": 100,
		"start_dialogue": "well hello buddy, again",
		"end_dialogue": "how rude buddy, again"
	},
	"tavern.3": {
		"name": "shop",
		"type": "shop",
		"start_dialogue": "welcome to the shop",
		"end_dialogue": "come again soon"
	},
	"tavern.4": {
		"name": "wizard",
		"type": "opponent",
		"sprite": "res://assets/art/characters/wizard.png",
		"healthpoints": 30,
		"deck": ["057", "058", "056", "044", "006", "006"],
		"chip_reward": 100,
		"start_dialogue": "well hello buddy, again, again",
		"end_dialogue": "how rude buddy, again, again"
	},
	"tavern.5": {
		"name": "fortune teller",
		"type": "fortune_teller",
		"start_dialogue": "Are you ready to have your fortune told?",
		"end_dialogue": "Good fortunes... Fate knows you will need it"
	}
}
