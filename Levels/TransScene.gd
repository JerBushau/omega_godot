extends Node2D

export var next = ""
export var trans_text = "NOW ENTERING HEDGELORD SPACE"
export var lvl = 0


signal intro_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	$TransTimer.start()
	$TextFadeInTimer.start()
	$CanvasLayer/RichTextLabel.text = trans_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(lvl):
		0:
			pass
		1:
			$CanvasLayer/Hedge.position.x += 360*delta
		2:
			$CanvasLayer/Bog.position.x += 360*delta
	pass


func _on_TransTimer_timeout():
	emit_signal("intro_complete")


func _on_TextFadeInTimer_timeout():
	$AnimationPlayer.play("fade-in")
	$TextFadeOutTimer.start()


func _on_TextFadeOutTimer_timeout():
	$AnimationPlayer.play_backwards("fade-in")
