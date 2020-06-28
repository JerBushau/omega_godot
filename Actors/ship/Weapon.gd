extends Node2D


const Bullet = preload("res://Objects/LazerBullet.tscn")
onready var ship = get_parent()
var damage = 3
var crit_chance = 5
var is_shooting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect('fire', self, 'shoot')
	Signals.connect('cease_fire', self, 'stop')


func _process(delta):
	var m_pos = get_global_mouse_position()
	var m_angle = get_angle_to(m_pos)
	var aim_speed = deg2rad(2.5)
	
	
	if m_angle - rotation < 1 and m_angle - rotation > -1:
		pass
#		aim_speed = deg2rad(1)
		
	if m_angle > 0.04:
		rotation += aim_speed
	elif m_angle < -0.04:
		rotation -= aim_speed
	else:
		pass


func stop():
	is_shooting = false
	$Muzzle/ShotTimer.stop()
	$AnimationPlayer.seek(0.1)


func shoot():
#	$AudioStreamPlayer2D.play()
	$AnimationPlayer.play("shoot")
	var direction = global_rotation
	if not is_shooting:
		is_shooting = true
		$Muzzle/ShotTimer.start()
		
	var muzzles = [$Muzzle2, $Muzzle]
	var is_crit = rand_range(0,100) <= crit_chance
	var final_dmg = damage / muzzles.size()
	
	if is_crit:
		final_dmg*=2 
	
	for m in muzzles:
		var bullet = Bullet.instance()
		bullet.init(final_dmg)
		bullet.is_crit = is_crit
		bullet.linear_velocity = Vector2(cos(direction), sin(direction)).normalized() * bullet.speed
		bullet.velocity = bullet.linear_velocity
		bullet.global_rotation = direction
		bullet.global_position = m.global_position
		bullet.set_as_toplevel(true)
		add_child(bullet)
	
	return true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
