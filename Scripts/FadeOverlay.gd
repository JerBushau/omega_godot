extends CanvasLayer

var is_fading = false

signal fade_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	var dad = get_parent()
	dad.connect("fade_from_black", self, "fade_from_black")
	dad.connect("fade_to_black", self, "fade_to_black")


func start_black():
	$CanvasModulate.modulate.a = 1


func fade_to_black():
	is_fading = true
	$AnimationPlayer.play("fade-out")
	yield($AnimationPlayer, "animation_finished")
	is_fading = false
	emit_signal("fade_complete")


func fade_from_black():
	is_fading = true
	$AnimationPlayer.play_backwards("fade-out")
	yield($AnimationPlayer, "animation_finished")
	is_fading = false
	
	emit_signal("fade_complete")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
