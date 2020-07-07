extends Node2D

#
#var intro_text = "NOW ENTERING HEDGELORD SPACE..."
#var game_over_text = ""
var is_level_over = false
var is_vicorious = false

var Intro = preload("res://Levels/TransScene.tscn")
var Level1 = preload("res://Levels/Level1/Level1.tscn")
var GameOver = preload("res://Levels/GameOver.tscn")

#onready var ship = $Level1/MainScene/Ship
#onready var boss = $Level1/MainScene/Hedgelord

var states
var current_state = 0
var game_over_message

# Called when the node enters the scene tree for the first time.
func _ready():
	var intro = Intro
	var level = Level1
	var game_over = GameOver
	
	states = {
		0: intro,
		1: level,
		2: game_over
	}

#	level.connect("level_complete", self, "change_state")
#	game_over.connect("game_over_complete", self, "change_state")
	
	print("Lv ready")
	
	change_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	check_game_status()
	pass


func release_previous_state():
	var previous_state =  get_children()

	if previous_state:
		previous_state[0].queue_free()


func check_level_outcome(wol):
	print('checking outcome ', wol)
	if wol:
		is_vicorious = true
		game_over_message = "VICTORY\nHEDGELORD DEFEATED"
	else:
		is_vicorious = false
		game_over_message = "YOU DIED\nDEFEATED BY HEDGELORD"


func create_intro():
	var intro = states[0].instance()
	intro.trans_text = "NOW ENTERING HEDGELORD SPACE..."
	intro.lvl = 1
	intro.connect("intro_complete", self, "change_state")
	
	return intro


func create_level():
	var level = states[1].instance()
	level.connect("level_complete", self, "change_state")
	
	return level


func create_game_over(wol):
	is_level_over = true
	check_level_outcome(wol)
	var go = states[2].instance()
	go.connect("game_over_complete", self, "change_state")
	go.go_text = game_over_message
	
	return go


func change_state(wol=false):
	print("changing level state ", current_state)
	var new_state
	
	release_previous_state()
	
	match current_state:
		0: 
			new_state = create_intro()
		1:
			new_state = create_level()
		2:
			new_state = create_game_over(wol)
		3:
			if is_vicorious:
				GameInfo.determine_state(true)
				return

			GameInfo.reset()
			return

	if new_state:
		add_child(new_state)
		current_state += 1
