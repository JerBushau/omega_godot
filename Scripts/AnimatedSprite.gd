extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	if frame > 4:
		flip_h = true 
	else:
		flip_h = false
