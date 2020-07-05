extends CanvasLayer

export var me = "lv1"
var is_fading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("fade_from_black", self, "fade_from_black")
	Signals.connect("fade_to_black", self, "fade_to_black")


func fade_to_black(should_change_scene=false, cb=null):
	is_fading = true
	$AnimationPlayer.play("fade-out")
	yield($AnimationPlayer, "animation_finished")
	if cb:
		cb.call_func()
	
	is_fading = false
	
	if should_change_scene:
		Signals.emit_signal("fade_complete", me                                                                                                                                                                     )


func fade_from_black(should_change_scene=false, cb=null):
	is_fading = true
	$AnimationPlayer.play_backwards("fade-out")
	yield($AnimationPlayer, "animation_finished")
	if cb:
		cb.call_func()
		
	is_fading = false
	
	if should_change_scene:
		Signals.emit_signal("fade_complete", me)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
