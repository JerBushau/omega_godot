extends Node2D

export var next = ""
export var trans_text = "NOW ENTERING HEDGELORD SPACE"
export var lvl = ""


signal intro_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	$TransTimer.start()
	$TextFadeInTimer.start()
	$CanvasLayer/RichTextLabel.text = trans_text
#	$CanvasLayer/HedgeAnimationPlayer.play("hedge_rotate")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$CanvasLayer/hedge.position.x += 7.5
	pass


func _on_TransTimer_timeout():
	emit_signal("intro_complete")
#	Signals.emit_signal("fade_complete", "trans")
#	var next_scene = GameInfo.next_scene


func _on_TextFadeInTimer_timeout():
	$AnimationPlayer.play("fade-in")
	$TextFadeOutTimer.start()
	pass # Replace with function body.


func _on_TextFadeOutTimer_timeout():
	$AnimationPlayer.play_backwards("fade-in")
	pass # Replace with function body.
