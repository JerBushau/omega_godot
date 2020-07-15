extends KinematicBody2D

var pm = ParticleManager
var speed = 7
var velocity = Vector2.UP
var steer_force = 300
var acceleration = Vector2.ZERO
var current_target
var dmg = 1
var hp = 75
var is_dead
var collision_pos
var collision_angle
var collision_velocity_at_angle

# Called when the node enters the scene tree for the first time.
func _ready():
	find_target()
	velocity = transform.x * speed
	rotation = velocity.angle()
	add_to_group("Player")


func find_target():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	if not enemies.size() > 0:
		return Vector2.LEFT
	current_target = enemies[enemies.size() - 1]


func init(starting_position):
	position = starting_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not current_target:
		find_target()
		
	if hp <= 0 and not is_dead:
		is_dead = true
		explode()
		queue_free()


func take_damage(dmg, is_crit=false, collision=null):
	hp -= dmg
	pm.create_particle_of_type(Particle_Types.SHIP_DMG, { "vel": velocity.angle(), "pos": global_position, "angle": -global_rotation })

func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		collision_pos = state.get_contact_collider_position(0)
		collision_angle = state.get_contact_local_normal(0).angle()
		collision_velocity_at_angle = state.get_contact_collider_velocity_at_position(0)


func seek():
	var steer = Vector2.ZERO
	if not current_target or not is_instance_valid(current_target):
		find_target()
		return steer
		
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
	speed = 5.5
	pass # Replace with function body.


func _on_AttackRadius_area_exited(_area):
	$AttackTimer.stop()
	pass # Replace with function body.


func _on_AttackTimer_timeout():
	if not is_instance_valid(current_target):
		return
	if current_target.has_method("take_damage"):
		var collision_obj = { "vel": velocity.angle(), "pos": position, "angle": rotation }
		current_target.take_damage(dmg, false, collision_obj)
	pass # Replace with function body.


func explode():
	var bodies = $ExplosionRadius.get_overlapping_bodies()
	
	for i in bodies:
		if i.has_method("take_damage") and not "Drone" in i.name:
			i.take_damage(5, false, {"pos": position, "angle": rotation})
	ParticleManager.create_particle_of_type(ParticleTypes.DRONE_EXPLOSION, {"pos": position, "angle": rotation})
	take_damage(hp)
	


func _on_LifeTimer_timeout():
	explode()
