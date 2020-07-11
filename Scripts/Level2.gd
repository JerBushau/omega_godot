extends Node2D

signal level_complete
signal fade_from_black
signal fade_to_black

var Fade = preload("res://Levels/FadeOverlay.tscn")
var fade
var level_over = false


# Called when the node enters the scene tree for the first time.
func _ready():
	fade = Fade.instance()
	fade.start_black()
	add_child(fade)
	emit_signal("fade_from_black")
	
	$MainScene/Ship.connect("level_end", self, "handle_level_over")
	$MainScene/Boss2.connect("level_end", self, "handle_level_over")
	
	$MainScene/Boss2/SpawnTimer.start()


func _process(delta):
	pass


func handle_level_over(is_win):
	if not level_over:
		level_over = true
		emit_signal("fade_to_black")
		yield(fade, "fade_complete")
		emit_signal("level_complete", is_win)
