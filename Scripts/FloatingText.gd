extends Label

func show_value(value, pos, travel=Vector2(0, -80), duration=0.25, spread=PI/2, crit=false, color=Color('ff7878')):
	text = str(value)
	rect_position = pos
	set("custom_colors/font_color", color)
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	rect_pivot_offset = rect_size
	if crit:
		modulate = Color(1, 0, 0, 1)
		$Tween.interpolate_property(self, "rect_scale",
			rect_scale*2, rect_scale*1.5,
			0.3, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.interpolate_property(self, "rect_position",
			rect_position, rect_position + movement,
			duration*2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
