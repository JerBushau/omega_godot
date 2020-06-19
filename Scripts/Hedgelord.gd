extends KinematicBody2D

signal damage_taken

const Eblast = preload("res://Objects/Energy_blast.tscn")
const DmgParticles = preload("res://Objects/HedgeHogSpineParticle.tscn")
onready var player = $"../Ship"
var hp = 600
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
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (hp <= 0 and not is_dead):
		is_dead = true
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


func take_damage(dmg: int, collision):
	hp -= dmg
	emit_signal('damage_taken', hp)
	var p = DmgParticles.instance()
	p.rotation = collision.angle
	p.set_emitting(true)
	p.position = collision.pos
	p.set_as_toplevel(true)
	add_child(p)


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
	$Energy_blast_attk_timer.wait_time = 0.1
	$Energy_blast_attk_timer.start()
	var direction
	if (is_instance_valid(player)):
		direction = get_angle_to(player.position)
	else: 
		direction = 1
	var eb = Eblast.instance()
	eb.global_position = self.global_position
	eb.linear_velocity = Vector2(cos(direction), sin(direction)).normalized() * eb.speed
	eb.velocity = eb.linear_velocity
	eb.global_rotation = direction
	eb.set_as_toplevel(true)
	add_child(eb)

func half_circle_blast():
	$Energy_blast_attk_timer.wait_time = 1
	$Energy_blast_attk_timer.start()
	for n in range(0, 180, 6):
		var direction = deg2rad(n)
		var eb = Eblast.instance()
		eb.global_position = self.global_position
		eb.linear_velocity = Vector2(cos(direction), sin(direction)).normalized() * eb.speed
		eb.global_rotation = direction
		eb.set_as_toplevel(true)
		add_child(eb)

func spiral_blast():
	$Energy_blast_attk_timer.wait_time = 0.001
	$Energy_blast_attk_timer.start()
	self.blast_angle += 2
	if self.blast_angle > 360:
		self.blast_angle = 0
	var direction = deg2rad(blast_angle)
	var eb = Eblast.instance()
	eb.global_position = self.global_position
	eb.linear_velocity = Vector2(cos(blast_angle), sin(blast_angle)).normalized() * eb.speed
	eb.global_rotation = direction
	eb.set_as_toplevel(true)
	add_child(eb)
	

func quick_burst():
	$Attack_timer.wait_time = 0.3
	$Energy_blast_attk_timer.wait_time = 0.1
	$Energy_blast_attk_timer.start()
	var direction
	if (is_instance_valid(player)):
		direction = get_angle_to(player.position)
	else: 
		direction = 1
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
		
	if attack_type == 0:
		straight_seeking_blast()
	elif attack_type == 1:
		quick_burst()
	elif attack_type == 2:
		spiral_blast()
	elif attack_type == 3:
		quick_burst()
	elif attack_type == 4:
		straight_seeking_blast()
	elif attack_type == 5:
		half_circle_blast()


func _on_Energy_blast_attk_timer_timeout():
	determine_attack(attk_type)


func _on_Attack_timer_timeout():
	if $Attack_timer.get_wait_time() != 3.75:
		$Attack_timer.set_wait_time(3.75)
	$Energy_blast_attk_timer.stop()
	is_attacking = false
	is_stopped = false
	path_follow.set_offset(path_follow.get_offset() + 6)
	$AnimationPlayer.play("Idle")


func _on_DeathTimer_timeout():
	queue_free()
	get_tree().change_scene("res://Levels/TitleScreen.tscn")
