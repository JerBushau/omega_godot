extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameInfo.set_boss(GameInfo.bosses.HEDGELORD)
	Signals.emit_signal("fade_from_black", null)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
