extends Node2D

var Fade = preload("res://Levels/FadeOverlay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var fade = Fade.instance()
	fade.me = "lv2"
	add_child(fade)
	Signals.emit_signal("fade_from_black", false, null)
	GameInfo.set_boss(GameInfo.bosses.BOSS2)


# Called every frame. 'welta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
