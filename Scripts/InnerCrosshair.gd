extends KinematicBody2D


var motion = Vector2(0, 0)
var velocity = Vector2.ZERO
onready var ship = $"../../../Ship"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = ship.position
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var outerCh = $"../OuterCrosshair"
	position = ship.position
#	var direction = Vector2(cos(targetAngle), sin(targetAngle));
	var desired = outerCh.position - position
	var distance = position.distance_to(outerCh.position)
	position += desired.normalized()*distance / 1.5
	
#	

