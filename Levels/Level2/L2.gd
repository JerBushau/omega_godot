extends Node2D

var Intro = preload("res://Levels/TransScene.tscn")
var Level2 = preload("res://Levels/Level2/Level2.tscn")
var GameOver = preload("res://Levels/GameOver.tscn")
var Base_Level = preload("res://Levels/BaseLevel.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var level2 = Base_Level.new()
	var level_setup = {
		"intro": {
			"scene": Intro,
			"info": {
				"text": "NOW ENTERING BOGGY SPACE...",
				"lvl": 2
			}
		},
		"level": {
			"scene": Level2,
			"info": {}
		},
		"game_over": {
			"scene": GameOver,
			"info": {
				"victory_text": "VICTORY\nBOGGY DEFEATED",
				"death_text": "YOU DIED\nDEFEATED BY BOGGY"
			}
		}
	}
	
	level2.setup(level_setup)
	add_child(level2)
