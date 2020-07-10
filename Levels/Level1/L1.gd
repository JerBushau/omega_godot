extends Node2D

var Intro = preload("res://Levels/TransScene.tscn")
var Level1 = preload("res://Levels/Level1/Level1.tscn")
var GameOver = preload("res://Levels/GameOver.tscn")
var Base_Level = preload("res://Levels/BaseLevel.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var level1 = Base_Level.new()
	var level_setup = {
		"intro": {
			"scene": Intro,
			"info": {
				"text": "NOW ENTERING HEDGELORD SPACE...",
				"lvl": 1
			}
		},
		"level": {
			"scene": Level1,
			"info": {}
		},
		"game_over": {
			"scene": GameOver,
			"info": {
				"victory_text": "VICTORY\nHEDGELORD DEFEATED",
				"death_text": "YOU DIED\nDEFEATED BY HEDGELORD"
			}
		}
	}
	
	level1.setup(level_setup)
	add_child(level1)
