extends Node2D

var Fade = preload("res://Levels/FadeOverlay.tscn")

signal level_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade = Fade.instance()
	fade.start_black()
	add_child(fade)
	Signals.emit_signal("fade_from_black")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func handle_game_over():
	pass


func send_level_complete(wol):
	emit_signal("level_complete", wol)
