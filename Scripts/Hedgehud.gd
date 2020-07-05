extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(who, values, signal_name):
	$Hp_main.setup(values, signal_name)
	$Label.text = who


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
