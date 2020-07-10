extends Node

var Fade = preload("res://Levels/FadeOverlay.tscn")

var on_done_signal
var fader

signal fade_from_black
signal fade_to_black


func _ready():
	create_fader()
	emit_signal("fade_from_black")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func create_fader():
	fader = Fade.instance()
	fader.start_black()
	add_child(fader)


#func _process(delta):
#	pass


func _on_LevelSelect_pressed():
	emit_signal("fade_to_black")
	yield(fader, "fade_complete")
	Signals.emit_signal("level_select")


func _on_Start_pressed():
	emit_signal("fade_to_black")
	yield(fader, "fade_complete")
	Signals.emit_signal("start_game")
