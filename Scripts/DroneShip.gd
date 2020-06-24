extends KinematicBody2D

var pm = ParticleManager
var speed = 8
var velocity = Vector2.UP
var steer_force = 300
var acceleration = Vector2.ZERO
var current_target
var dmg = 1
var hp = 75
var collision_pos
var collision_angle
var collision_velocity_at_angle

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = transform.x * speed
	rotation = velocity.angle()
	pass # Replace with function body.


func init(new_target, starting_position):
	current_target = new_target
	position = starting_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp <= 0:
		queue_free()


func take_damage(dmg, collision=null):
	hp -= dmg
	pm.create_particle_of_type(Particle_Types.SHIP_DMG, { "vel": velocity.angle(), "pos": position, "angle": -rotation })

func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		collision_pos = state.get_contact_collider_position(0)
		collision_angle = state.get_contact_local_normal(0).angle()
		collision_velocity_at_angle = state.get_contact_collider_velocity_at_position(0)


func seek():
	var steer = Vector2.ZERO
	if current_target:
		var desired = (current_target.position - position).normalized() * speed
		steer = (desired - velocity)
	return steer	

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	move_and_collide(velocity)
	
#	linear_velocity.linear_interpolate()


func _on_AttackRadius_body_entered(_body):
	$AttackTimer.start()
	pass # Replace with function body.


func _on_AttackRadius_area_exited(_area):
	$AttackTimer.stop()
	pass # Replace with function body.


func _on_AttackTimer_timeout():
	if current_target.has_method("take_damage"):
		var collision_obj = { "vel": velocity.angle(), "pos": position, "angle": rotation }
		current_target.take_damage(dmg, false, collision_obj)
	pass # Replace with function body.
