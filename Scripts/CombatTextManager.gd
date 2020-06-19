extends Node2D

var FCT = preload("res://Objects/FloatingText.tscn")

export var travel = Vector2(0, -80)
export var duration = 0.75
export var spread = PI/2

func show_value(value, pos, crit=false):
	var fct = FCT.instance()
	add_child(fct)
	fct.show_value(value, pos, travel, duration, spread, crit)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
