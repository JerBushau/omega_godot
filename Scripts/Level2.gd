extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.emit_signal("fade_from_black")
	GameInfo.set_boss(GameInfo.bosses.BOSS2)


# Called every frame. 'welta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
