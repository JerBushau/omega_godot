extends Camera2D

onready var ship = get_parent() 

# Called when the node enters the scene tree for the first time.
func _ready():
	ship.connect("damage_taken", self, "shake")
	pass # Replace with function body.


func shake():
	var shake_amount = 10.0
	$Reset_cam_timer.start()

	set_offset(Vector2( \
		rand_range(-1.0, 1.0) * shake_amount, \
		rand_range(-1.0, 1.0) * shake_amount \
	))
	
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Reset_cam_timer_timeout():
	offset = Vector2(0,0)
