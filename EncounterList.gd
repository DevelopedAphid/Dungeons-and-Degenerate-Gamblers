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
		"type": "shop"
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
	}
}
