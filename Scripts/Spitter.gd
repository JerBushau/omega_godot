extends KinematicBody2D

onready var combatTextMngr = $"../Interface/CombatText"
const Eblast = preload("res://Objects/SpitterSpit.tscn")
var is_attacking = false
var target
var hp = 20
var speed = 0.75
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemies")
	$AttackTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	find_target()
	$Sprite.rotation = velocity.angle() - deg2rad(90)
	pass


func seek():
	var steer = Vector2.ZERO
	if not target or not is_instance_valid(target):
		return steer
		
	var desired = (Vector2(target.position.x + rand_range(-100, 100), target.position.y - rand_range(100, 200)) - position).normalized() * speed
	steer = (desired - velocity)
	return steer


func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	$Sprite.rotation = velocity.angle() - deg2rad(90)
	move_and_collide(velocity)


func take_damage(dmg, is_crit=false, collision=null):
	hp -= dmg
	ParticleManager.create_particle_of_type(Particle_Types.BOSS2_DMG, collision)
	combatTextMngr.show_value(str(dmg), position + Vector2(0, -50), is_crit)
	if hp <= 0:
		ParticleManager.create_particle_of_type(Particle_Types.BOSS2_DEATH, collision)
		queue_free()


func setup(pos):
	position = pos


func find_target():
	var possible_targets = get_tree().get_nodes_in_group("Player")
	
	if possible_targets:
		target = possible_targets[possible_targets.size()-1]
		return target
	
	return null


func quick_burst():
	var atk_dur = 0.51
	var atk_speed = 0.1
	target = find_target()
	
	if not target:
		print('fail')
		return
	
	var direction = get_angle_to(target.position)
	
	blast(atk_speed, direction, atk_dur)


func blast(attack_speed_duration=1, direction=1, attack_duration=3.75):
	$AttackTimer.wait_time = attack_duration
	$ShotTimer.wait_time = attack_speed_duration
	var eb = Eblast.instance()
	eb.global_position = self.global_position
	eb.linear_velocity = Vector2(cos(direction), sin(direction)).normalized() * eb.speed
	eb.velocity = eb.linear_velocity
	eb.global_rotation = direction
	eb.set_as_toplevel(true)
	eb.set_collision_mask_bit(2, false)
	get_parent().add_child(eb)


func _on_AttackTimer_timeout():
	is_attacking = !is_attacking
	
	if is_attacking:
		$ShotTimer.start()
	else:
#		global_rotation = 0
		$ShotTimer.stop()


func _on_ShotTimer_timeout():
	quick_burst()
