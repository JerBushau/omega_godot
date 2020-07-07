extends Node2D

#
#var intro_text = "NOW ENTERING HEDGELORD SPACE..."
#var game_over_text = ""
var is_level_over = false
var is_vicorious = false

var Intro = preload("res://Levels/TransScene.tscn")
var Level2 = preload("res://Levels/Level2/Level2.tscn")
var GameOver = preload("res://Levels/GameOver.tscn")

#onready var ship = $Level2/MainScene/Ship
#onready var boss = $Level2/MainScene/Hedgelord

var states
var current_state = 0
var game_over_message

# Called when the node enters the scene tree for the first time.
func _ready():
	var intro = Intro
	var level = Level2
	var game_over = GameOver
	
	states = {
		0: intro,
		1: level,
		2: game_over
	}

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
	if wol:
		is_vicorious = true
		game_over_message = "VICTORY\nBOGGY DEFEATED"
	else:
		is_vicorious = false
		game_over_message = "YOU DIED\nDEFEATED BY BOGGY"

func change_state(wol=false):
	print("changing level state ", current_state)
	var new_state
	
	release_previous_state()
	
	match current_state:
		0: 
			new_state = states[current_state].instance()
			new_state.trans_text = "NOW ENTERING BOGGY SPACE..."
			new_state.lvl = 2
			new_state.connect("intro_complete", self, "change_state")
		1:
			new_state = states[current_state].instance()
			new_state.connect("level_complete", self, "change_state")
		2:
			is_level_over = true
			check_level_outcome(wol)
			new_state = states[current_state].instance()
			new_state.connect("game_over_complete", self, "change_state")
			new_state.go_text = game_over_message
		3:
			if is_vicorious:
				GameInfo.determine_state()
				print("congrats more lvls soon to come")
				return

			GameInfo.reset()
			return

	if new_state:
		add_child(new_state)
		current_state += 1
