extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$TransTimer.start()
	$TextFadeInTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TransTimer_timeout():
	print('change now')
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_TextFadeInTimer_timeout():
	$AnimationPlayer.play("fade-in")
	$TextFadeOutTimer.start()
	pass # Replace with function body.


func _on_TextFadeOutTimer_timeout():
	$AnimationPlayer.play_backwards("fade-in")
	pass # Replace with function body.
