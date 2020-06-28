extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("fade_from_black", self, "fade_from_black")
	Signals.connect("fade_to_black", self, "fade_to_black")


func fade_to_black(cb):
	$AnimationPlayer.play("fade-out")
	yield($AnimationPlayer, "animation_finished")
	if cb:
		cb.call_func()
	


func fade_from_black(cb):
	print('yes')
	$AnimationPlayer.play_backwards("fade-out")
	yield($AnimationPlayer, "animation_finished")
	if cb:
		cb.call_func()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
