extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("ship_damage_taken", self, "shake")
	pass # Replace with function body.


func shake():
	var shake_amount = 12.0
	$Reset_cam_timer.start()

	var rand_shake = Vector2( \
		rand_range(-1.0, 1.0) * shake_amount, \
		rand_range(-1.0, 1.0) * shake_amount \
	)
	
	$Tween.interpolate_property(
		self, 
		"offset", 
		offset, 
		rand_shake, 
		0.05)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Reset_cam_timer_timeout():
	offset = Vector2(0,0)
