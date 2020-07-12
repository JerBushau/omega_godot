extends "res://Actors/BaseActor.gd"

onready var combatTextMngr = $"../Interface/CombatText"
const Eblast = preload("res://Objects/SpitterSpit.tscn")
var is_attacking = false
var target


# Called when the node enters the scene tree for the first time.
func _ready():
	max_hp = 20
	hp = max_hp
	speed = 75
	
	add_to_group("Enemies")
	$AttackTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	find_target()


func seek():
	var steer = Vector2.ZERO
	if not target or not is_instance_valid(target):
		return steer
		
	var desired = (Vector2(target.position.x + rand_range(-100, 100), target.position.y - rand_range(200, 300)) - position).normalized() * speed
	steer = (desired - velocity)
	return steer


func _physics_process(delta):
	move(seek())


func take_damage(dmg, is_crit=false, collision=null):
	.take_damage(dmg)
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
		$Sprite.rotation = get_angle_to(target.position) - deg2rad(90)
		return target
	
	return null


func quick_burst():
	var atk_dur = 0.50
	var atk_speed = 0.15
	target = find_target()
	
	if not target:
		print('fail')
		return
	var offsets = [25, 0, -25]
	for i in range(3):
		var direction = get_angle_to(target.position) + deg2rad(offsets[i])
		print(direction)
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
		$ShotTimer.stop()


func _on_ShotTimer_timeout():
	quick_burst()
