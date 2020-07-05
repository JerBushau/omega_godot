extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = GameInfo.game_over_message


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	Signals.emit_signal("fade_complete", "go")
	pass


func _on_TextFadeOutTimer_timeout():
	$AnimationPlayer.play("text-out")
