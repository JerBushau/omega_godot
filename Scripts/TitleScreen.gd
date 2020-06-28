extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.emit_signal("fade_from_black", null)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control/AnimationPlayer.play("wobble")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var cb = funcref(self, 'fade_callback')
	Signals.emit_signal("fade_to_black", cb)

func fade_callback():
		get_tree().change_scene("res://Levels/TransScene.tscn")
