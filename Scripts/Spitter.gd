extends "res://Actors/BaseActor.gd"

onready var combatTextMngr = $"../Interface/CombatText"
const Eblast = preload("res://Objects/SpitterSpit.tscn")
var is_attacking = false
var target
var attack_offset_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	max_hp = 20
	hp = max_hp
	speed = 75
	
	bounce_in()
	
	add_to_group("Enemies")
	$AttackTimer.start()


func bounce_in():
	var original_scale = Vector2(1,1)
	$Tween.interpolate_property(self, "scale", Vector2(0,0), original_scale*1.2, 0.15)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(self, "scale", scale, original_scale/1.2, 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.interpolate_property(self, "scale", scale, original_scale, 0.1)
	$Tween.start()
	yield($Tween, "tween_all_completed")

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
	var should_invert = randf() > 0.50
	var initial_horizontal_velocity =  rand_range(175, 275)
	if should_invert:
		initial_horizontal_velocity *= -1 
	print(should_invert)
	velocity = Vector2(initial_horizontal_velocity, 0)


func find_target():
	var possible_targets = get_tree().get_nodes_in_group("Player")
	
	if possible_targets:
		target = possible_targets[possible_targets.size()-1]
		$Sprite.rotation = get_angle_to(target.position) - deg2rad(90)
		return target
	
	return null


func quick_burst():
	var atk_dur = 0.50
	var atk_speed = 0.24
	target = find_target()
	
	if not target:
		print('fail')
		return
	var possible_offsets = [
		[30, 0, -30],
		[40, 0, -40],
		[20, 0, -20]
	]
	var random_offset =  possible_offsets[randi() % possible_offsets.size()]
	# use specific to offset in a particualr order
	var specific_offset = possible_offsets[attack_offset_index]
	for i in range(3):
		var direction = get_angle_to(target.position) + deg2rad(random_offset[i])
		blast(atk_speed, direction, atk_dur)
	attack_offset_index += 1
	if attack_offset_index > 2:
		attack_offset_index = 0

func blast(attack_speed_duration=1, direction=1, attack_duration=3.75):
#	$AttackTimer.wait_time = attack_duration
#	$ShotTimer.wait_time = attack_speed_duration
	$AnimationPlayer.play("spit")
	var eb = Eblast.instance()
	eb.global_position = $Position2D.global_position
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
