extends Node2D

export var go_text = "test"

signal game_over_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Label.text = go_text
	$AnimationPlayer.play("text-out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Timer_timeout():
	emit_signal("game_over_complete")

