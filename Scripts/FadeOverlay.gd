extends CanvasLayer

var is_fading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("fade_from_black", self, "fade_from_black")
	Signals.connect("fade_to_black", self, "fade_to_black")


func start_black():
	$CanvasModulate.modulate.a = 1


func fade_to_black(custom_signal="fade_complete", cb=null, custom_args=null):
	is_fading = true
	$AnimationPlayer.play("fade-out")
	yield($AnimationPlayer, "animation_finished")
	if cb:
		cb.call_func()
	
	is_fading = false
	
	if custom_args:
		Signals.emit_signal(custom_signal, custom_args)
		return
	else:
		Signals.emit_signal(custom_signal)
	

func fade_from_black(custom_signal="fade_complete", cb=null):
	is_fading = true
	$AnimationPlayer.play_backwards("fade-out")
	yield($AnimationPlayer, "animation_finished")
	if cb:
		cb.call_func()
		
	is_fading = false
	
	Signals.emit_signal(custom_signal)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
