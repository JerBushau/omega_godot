extends Node2D


const ship = preload("res://Actors/ship/Ship.tscn")
const spitter = preload("res://Actors/Spitter/Spitter.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_0) and just_pressed:
		var s = spitter.instance()
		s.setup(Vector2(0, -192))
		add_child(s)

	if Input.is_key_pressed(KEY_1) and just_pressed:
		$Ship.reset()
		$Interface/Crosshair.visible = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
