extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$TransTimer.start()
	$TextFadeInTimer.start()
	$CanvasLayer/RichTextLabel.text = GameInfo.trans_data.active
	print("text:",  GameInfo.trans_data.active)
#	$CanvasLayer/HedgeAnimationPlayer.play("hedge_rotate")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$CanvasLayer/hedge.position.x += 7.5
	pass


func _on_TransTimer_timeout():
	Signals.emit_signal("fade_complete", "trans")
#	var next_scene = GameInfo.next_scene
#	get_tree().change_scene("res://Levels/{}.tscn".format(next_scene))


func _on_TextFadeInTimer_timeout():
	$AnimationPlayer.play("fade-in")
	$TextFadeOutTimer.start()
	pass # Replace with function body.


func _on_TextFadeOutTimer_timeout():
	$AnimationPlayer.play_backwards("fade-in")
	pass # Replace with function body.
