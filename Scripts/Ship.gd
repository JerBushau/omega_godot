class_name Ship
extends KinematicBody2D

signal level_end

onready var combatTextMngr = $"../Interface/CombatText"
onready var pm = ParticleManager
export (int) var speed = 300
const HUD = preload("res://ShipHUD.tscn")
const MAX_SPEED = 5
var velocity = Vector2()
export var max_hp = 150
export var shield = 100
export var friction = 0.001
export var acceleration = 0.01
var hp = max_hp
var is_dead = false

func _ready():
	var ship_hud = HUD.instance()
	ship_hud.init(self)
	add_child(ship_hud)
	add_to_group("Player")


func get_input():
	var input = Vector2()
	
	if is_dead:
		return input
	
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
# no up and down movement in original game
#	if Input.is_action_pressed('down'):
#		input.y += 1
#	if Input.is_action_pressed('up'):
#		input.y -= 1
	if Input.is_action_just_pressed('click'):
		Signals.emit_signal('fire')
	if Input.is_action_just_released("click"):
		Signals.emit_signal('cease_fire')
	if Input.is_action_just_pressed("shield"):
		if not $Shield.is_active and not $Shield.on_cooldown:
			Signals.emit_signal("activate_shield")
		else: 
			Signals.emit_signal("deactivate_shield")
	if Input.is_action_just_pressed("drones"):
		Signals.emit_signal("release_ship_drones")
	if Input.is_action_just_pressed("pause"):
		Signals.emit_signal("pause", true)
		
	
	return input
	
	
func _process(_delta):
	if hp == max_hp:
		$HpRegenTimer.stop()
	if (hp <= 0 and not is_dead):
		die()


func die():
	is_dead = true
	$DeathExplosion.play()
	Signals.emit_signal("level_over", "lose")
	Signals.emit_signal("ship_dead")
	Signals.emit_signal("deactivate_shield")
	$ShipCollisionShape.disabled = true
	$Sprite.visible = false
	$ShipDeathSprite.visible = true
	$AnimationPlayer.play("Death")
	$Weapon.visible = false
	


func update_hp(new_hp):
	hp = new_hp
	Signals.emit_signal("ship_hp_change", hp)


func take_damage(dmg: int, collision=null):
	var new_hp = hp - dmg
	update_hp(new_hp)
	
	if $Shield.is_active:
		return

	$HitTimer.start()

	if not collision:
		return
		
	$HpRegenTimer.stop()
#	$Hit.play()
	Signals.emit_signal("ship_damage_taken")
	pm.create_particle_of_type(Particle_Types.SHIP_DMG, collision)


func gain_hp(hp_to_gain):
	if hp == max_hp or is_dead:
		return
	
	var new_hp = hp_to_gain + hp
	if new_hp >= max_hp:
		new_hp = max_hp
		combatTextMngr.show_value("MAX SHIELDS", position + Vector2(0, -50), null, Color('7893ff'))
	update_hp(new_hp)


func _physics_process(_delta):
	position.x = clamp(position.x, $ShipCamera.limit_left+50, $ShipCamera.limit_right-50)
	position.y = clamp(position.y, $ShipCamera.limit_top+50, $ShipCamera.limit_bottom-50)
	
	if is_dead:
		return
	
	var m_pos = $Weapon.rotation
	var aim_speed = deg2rad(1)
	
	if m_pos > 3 or m_pos < -3:
		aim_speed = deg2rad(6)
	elif m_pos > 0.8 or m_pos < -0.8:
		aim_speed = deg2rad(3)
	
	if m_pos > 0.05:
		rotation += aim_speed
	elif m_pos < -0.05:
		rotation -= aim_speed
	else:
		pass
		
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)


func _on_ShotTimer_timeout():
	if not is_dead:
		Signals.emit_signal('fire')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Death':
		$DeathTimer.start()
		$HitTimer.stop()
		$HpRegenTimer.stop()
		$ShipDeathSprite.visible = false
		visible = false


func _on_DeathTimer_timeout():
	emit_signal("level_end", false)
	


func _on_HitTimer_timeout():
	if $HpRegenTimer.is_stopped():
		$HpRegenTimer.start()
		combatTextMngr.show_value("REGEN", position + Vector2(0, -50), null, Color('7893ff'))


func _on_HpRegenTimer_timeout():
	if $Shield.is_active:
		return
	var amount = 2
	gain_hp(amount)
	combatTextMngr.show_value(str("+", amount), position + Vector2(0, -50), null, Color('7893ff'))
