extends KinematicBody2D

var motion = Vector2(0, 0)
onready var ship = $"../../../Node2D/Ship"
onready var weapon = $"../../../Node2D/Ship/Weapon/"
var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	position = weapon.global_position
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position = weapon.global_position
	var outerCh = $"../OuterCrosshair"
	var targetAngle = weapon.global_rotation
	rotation = targetAngle
#	
	var direction = Vector2(cos(targetAngle), sin(targetAngle));
	var desired = outerCh.position - position
	var distance = position.distance_to(outerCh.position)
	position += desired.normalized()*distance / 1.5
	
#	

