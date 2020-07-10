extends KinematicBody2D

const Eblast = preload("res://Objects/SpitterSpit.tscn")
var is_attacking = false
var target
var hp = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttackTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func take_damage(dmg, is_crit=false, collision=null):
	hp -= dmg
	ParticleManager.create_particle_of_type(Particle_Types.BOSS2_DMG, collision)
	
	if hp <= 0:
		queue_free()


func setup(pos):
	position = pos


func find_target():
	var possible_targets = get_tree().get_nodes_in_group("Player")
	
	if possible_targets:
		target = possible_targets[0]
		return target
	
	return null


func quick_burst():
	var atk_dur = 0.5
	var atk_speed = 0.1
	target = find_target()
	
	if not target:
		print('fail')
		return
	
	var direction = get_angle_to(target.position)
	$Sprite.global_rotation = direction - deg2rad(90)
	
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
		global_rotation = 0
		$ShotTimer.stop()


func _on_ShotTimer_timeout():
	quick_burst()
