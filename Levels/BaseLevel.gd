extends Node2D

var is_level_over = false
var is_vicorious = false

var states
var current_state = 0
var game_over_message

var intro_info
var level_info
var game_over_info

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func setup(data):
	var intro = data.intro.scene
	var level = data.level.scene
	var game_over = data.game_over.scene
	
	intro_info = data.intro.info
	level_info = data.level.info
	game_over_info = data.game_over.info
	

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
	print('checking outcome ', wol)
	if wol:
		is_vicorious = true
		game_over_message = game_over_info.victory_text
	else:
		is_vicorious = false
		game_over_message = game_over_info.death_text


func create_intro():
	var intro = states[0].instance()
	intro.trans_text = intro_info.text
	intro.lvl = intro_info.lvl
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
