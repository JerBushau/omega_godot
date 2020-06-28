extends KinematicBody2D

const Eblast = preload("res://Objects/Energy_blast.tscn")
onready var combatTextMngr = $"../../Interface/CombatText"
var pm = ParticleManager
onready var player = $"../Ship"
var hp = 700
var move_speed = 25
onready var path_follow = get_node('../Path2D/PathFollow2D')
var velocity = Vector2()
var is_attacking = false
var is_stopped = false
var attk_type
var blast_angle = 0
var is_dead = false

var attk_points = [
	[600, 605],
	[1050, 1055],
	[1280, 1285],
	[1495, 1500],
	[1945, 1950],
	[2540, 2545]
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (hp <= 0 and not is_dead):
		is_dead = true
		Signals.emit_signal("level_over", "win")
		$Sprite.visible = false
		$HedgeLordDeathSprite.visible = true
		$AnimationPlayer.play("Death")
		$DeathTimer.start()
		set_collision_mask(0)


func _physics_process(delta):
	if not is_stopped and not is_dead:
		for i in range(attk_points.size()):
			if path_follow.get_offset() > attk_points[i][0] and path_follow.get_offset() < attk_points[i][1] and not is_attacking:
				attack(i)
			else:
				path_follow.set_offset(path_follow.get_offset() + move_speed * delta)
	elif is_dead:
		velocity.y += 1
		move_and_slide(velocity)


func take_damage(dmg: int, crit, collision):
	hp -= dmg
	Signals.emit_signal('hedge_hp_change', hp)
	pm.create_particle_of_type(Particle_Types.HEDGELORD_DMG, collision)
	
	if not is_dead:
		$Sprite.modulate = Color(1.2, 1.2, 1.2, 1)
		$HitTimer.start()
		combatTextMngr.show_value(str(dmg), position + Vector2(0, -75), crit)


func attack(type: int):
	if is_dead:
		return
	is_attacking = true
	is_stopped = true
	attk_type = type
	$AnimationPlayer.play("Attack")
	determine_attack(attk_type)
	$Attack_timer.start()


func straight_seeking_blast():
	var atk_speed = 0.1
	var direction
	if (is_instance_valid(player)):
		direction = get_angle_to(player.position)
	else: 
		direction = 1
	
	energy_blast(atk_speed, direction)

func half_circle_blast():
	var atk_speed = 1
	
	for n in range(0, 180, 6):
		var direction = deg2rad(n)
		energy_blast(atk_speed, direction)


func spiral_blast():
	var atk_speed = 0.009
	self.blast_angle += 2
	if self.blast_angle > 360:
		self.blast_angle = 0
	var direction = self.blast_angle
	
	energy_blast(atk_speed, direction)

func quick_burst():
	var atk_dur = 0.3
	var atk_speed = 0.1
	var direction = get_angle_to(player.position)
	
	energy_blast(atk_speed, direction, atk_dur)


func energy_blast(attack_speed_duration=1, direction=1, attack_duration=3.75):
	$ShootSound.play()
	$Attack_timer.wait_time = attack_duration
	$Energy_blast_attk_timer.wait_time = attack_speed_duration
	$Energy_blast_attk_timer.start()

	var eb = Eblast.instance()
	eb.global_position = self.global_position
	eb.linear_velocity = Vector2(cos(direction), sin(direction)).normalized() * eb.speed
	eb.velocity = eb.linear_velocity
	eb.global_rotation = direction
	eb.set_as_toplevel(true)
	add_child(eb)


func determine_attack(attack_type: int):
	if is_dead:
		return
	
	match(attack_type):
		0:
			straight_seeking_blast()
		1:
			quick_burst()
		2:
			spiral_blast()
		3:
			quick_burst()
		4:
			straight_seeking_blast()
		5:
			half_circle_blast()


func _on_Energy_blast_attk_timer_timeout():
	determine_attack(attk_type)


func _on_Attack_timer_timeout():
	$Energy_blast_attk_timer.stop()
	is_attacking = false
	is_stopped = false
	if is_dead:
		return
	if $Attack_timer.get_wait_time() != 3.75:
		$Attack_timer.set_wait_time(3.75)
	$Energy_blast_attk_timer.stop()
	is_attacking = false
	is_stopped = false
	path_follow.set_offset(path_follow.get_offset() + 6)
	$AnimationPlayer.play("Idle")


func change_to_title():
	get_tree().change_scene("res://Levels/GameOver.tscn")
	queue_free()



func _on_DeathTimer_timeout():
	var cb = funcref(self, "change_to_title")
	Signals.emit_signal("fade_to_black", cb)


func _on_HitTimer_timeout():
	$Sprite.modulate = Color(1,1,1,1)
