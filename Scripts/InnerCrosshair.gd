extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var motion = Vector2(0, 0)
onready var ship = $"../../../Ship" 
var targetPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var targetPosition = $"../OuterCrosshair".position
	var speed = 45
	var targetVector = (targetPosition - position).normalized()
	
	if position == targetPosition:
		return
	
	motion += targetVector
	motion = motion * speed * delta
	
	position += motion
