extends Node

var initial_title = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("start_game", self, "start_game")
	Signals.connect("level_select", self, "level_select")
	Signals.connect("pause", self, "pause_game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


var states ={
	0: "Title/TitleScreen",
	1: "LevelSelect",
	2: "Level1/L1",
	3: "Level2/L2"
}

var current_state = 0


func level_select():
	change_to(1)


func start_game():
	change_to(2)


func change_state(wol):
	print("win ", wol)
	if wol:
		current_state += 1
	else:
		current_state = 0


func reset():
	initial_title = false
	current_state = 0
	determine_state()


func determine_state(wol=false):
	print("Determining game state. Current state: ", current_state)
	match(current_state):
		0:
			change_state(wol)
		1:
			level_select()
		3:
			reset()
		_:
			change_state(wol)
	
	print("New game state: ", current_state)
	change_to(current_state)


func change_to(scene):
	current_state = scene
	print("changing game state ", states[scene])
	get_tree().change_scene("res://Levels/{scene}.tscn".format({ "scene": states[scene] }))


func pause_game(is_paused):
	get_tree().paused = is_paused
