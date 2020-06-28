extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Signals.connect("pause", self, "pause_handler")
	pause_mode = Node.PAUSE_MODE_PROCESS


func pause_handler():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CenterContainer/Control/Button.visible = !$CenterContainer/Control/Button.visible
	get_tree().paused = !get_tree().paused 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$CenterContainer/Control/Button.visible = !$CenterContainer/Control/Button.visible
	get_tree().paused = !get_tree().paused
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
