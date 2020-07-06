extends Node

var initial_title = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("title_complete", self, "determine_state")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


var states ={
	0: "TitleScreen",
	1: "Level1/L1",
	2: "Level2/L2"
}

var current_state = 0


func change_state(wol):
	if wol:
		current_state += 1
	else:
		current_state = 0


func reset():
	initial_title = false
	current_state = 0
	determine_state()


func determine_state(wol=false):
	print("determine game state ", current_state)
	match(current_state):
		0:
			change_state(wol)
		2:
			reset()
		_:
			change_state(wol)
	
	change_to(current_state)


func change_to(scene):
	print("changing game state ", states[scene])
	get_tree().change_scene("res://Levels/{scene}.tscn".format({ "scene": states[scene] }))
