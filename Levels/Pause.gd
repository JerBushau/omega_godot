extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	Signals.connect("pause", self, "pause_handler")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func pause():
	pass


func unpause():
	pass


func pause_handler(is_paused):
	var mouse_mode = Input.MOUSE_MODE_VISIBLE if is_paused else Input.MOUSE_MODE_HIDDEN
	$CenterContainer/Control/Button.visible = is_paused
	Input.set_mouse_mode(mouse_mode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Signals.emit_signal("pause", false)
