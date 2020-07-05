extends Node2D

var Fade = preload("res://Levels/FadeOverlay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade = Fade.instance()
	fade.me = "lv1"
	add_child(fade)
	Signals.emit_signal("fade_from_black", null)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
