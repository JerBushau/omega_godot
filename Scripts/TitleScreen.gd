extends Node

var Fade = preload("res://Levels/FadeOverlay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade = Fade.instance()
	fade.me = "title"
	add_child(fade)
	Signals.emit_signal("fade_from_black", false, null)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	$Control/AnimationPlayer.play("wobble")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var cb = funcref(self, 'fade_callback')
	Signals.emit_signal("fade_to_black", true, null)

func fade_callback():
		pass
