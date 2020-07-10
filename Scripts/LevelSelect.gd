extends Node2D

signal fade_from_black
signal fade_to_black

var Fade = preload("res://Levels/FadeOverlay.tscn")
var fade

# Called when the node enters the scene tree for the first time.
func _ready():
	fade = Fade.instance()
	fade.start_black()
	add_child(fade)

	emit_signal("fade_from_black")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Level1Button_pressed():
	emit_signal("fade_to_black")
	yield(fade, "fade_complete")
	GameInfo.change_to(2)


func _on_Level2Button_pressed():
	emit_signal("fade_to_black")
	yield(fade, "fade_complete")
	GameInfo.change_to(3)


func _on_Button_pressed():
	emit_signal("fade_to_black")
	yield(fade, "fade_complete")
	GameInfo.change_to(0)
