extends Node2D

var Fade = preload("res://Levels/FadeOverlay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade = Fade.instance()
	fade.start_black()
	add_child(fade)

	Signals.emit_signal("fade_from_black")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Level1Button_pressed():
	GameInfo.change_to(2)
	pass # Replace with function body.


func _on_Level2Button_pressed():
	GameInfo.change_to(3)
	pass # Replace with function body.
