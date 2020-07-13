extends "res://Actors/BaseActor.gd"

signal level_end

onready var combatTextMngr = $"../Interface/CombatText"
onready var pm = ParticleManager
const HUD = preload("res://ShipHUD.tscn")
const MAX_SPEED = 5
export var shield = 100
var ship_hud
var hp_regen_amount = 2
var eight_d_control = false

func _ready():
	speed = 325
	max_hp = 150
	hp = max_hp
	acceleration = 0.03
	friction = 0.007

	ship_hud = HUD.instance()
	ship_hud.init(self)
	add_child(ship_hud)
	add_to_group("Player")


func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_9) and just_pressed:
		eight_d_control = !eight_d_control


func get_input():
	var input = Vector2()
	
	if is_dead:
		return input
	
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if eight_d_control:
		if Input.is_action_pressed('down'):
			input.y += 1
		if Input.is_action_pressed('up'):
			input.y -= 1
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
	activate_regen()

	if (hp <= 0 and not is_dead):
		die()


func reset():
	is_dead = false
	gain_hp(max_hp)
	$ShipCollisionShape.disabled = false
	$Sprite.visible = true
	$ShipDeathSprite.visible = false
	$Weapon.visible = true
	visible = true
	


func die():
	is_dead = true
	Signals.emit_signal("ship_dead")
	Signals.emit_signal("deactivate_shield")
	$HitTimer.stop()
	$HpRegenTimer.stop()
	$DeathExplosion.play()
	$ShipCollisionShape.disabled = true
	$Sprite.visible = false
	$ShipDeathSprite.visible = true

	$AnimationPlayer.play("Death")
	$Weapon.visible = false
	yield($AnimationPlayer, "animation_finished")
	$DeathTimer.start()
	visible = false


func take_damage(dmg: int, collision=null):
	.take_damage(dmg)
	
	$HitTimer.start()
	
	if $Shield.is_active:
		return

	if not collision:
		return
	
	deactivate_regen()
	#change signal name to camera shake or something
	Signals.emit_signal("ship_damage_taken")
	pm.create_particle_of_type(Particle_Types.SHIP_DMG, collision)


func gain_hp(hp_to_gain):
	var full_hp = hp == max_hp
	
	if full_hp or is_dead:
		return

	.gain_hp(hp_to_gain)

	if full_hp:
		deactivate_regen()
		combatTextMngr.show_value("MAX SHIELDS", position + Vector2(0, -50), null, Color('7893ff'))



func rotate_ship():
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


func clamp_to_screen():
	position.x = clamp(position.x, $ShipCamera.limit_left+50, $ShipCamera.limit_right-50)
	if not eight_d_control:
		position.y = clamp(position.y, $ShipCamera.limit_bottom-50, $ShipCamera.limit_bottom-50)
	else: 
		position.y = clamp(position.y, $ShipCamera.limit_top-50, $ShipCamera.limit_bottom-50)


func _physics_process(_delta):
	if is_dead:
		return

	var direction = get_input()
	rotate_ship()
	.move(direction)
	clamp_to_screen()


func _on_ShotTimer_timeout():
	if not is_dead:
		Signals.emit_signal('fire')


func _on_DeathTimer_timeout():
	emit_signal("level_end", false)
	


func activate_regen():
	var regen_ready = $HitTimer.is_stopped()
	var regen_stopped = $HpRegenTimer.is_stopped()
	var hp_full = hp == max_hp
	var should_activate = (
		regen_ready 
		and regen_stopped 
		and not hp_full
		and not is_dead
		and not $Shield.is_active)
	
	if should_activate:
		$HpRegenTimer.start()
		combatTextMngr.show_value("REGEN", position + Vector2(0, -50), null, Color('7893ff'))


func deactivate_regen():
	$HpRegenTimer.stop()


func _on_HpRegenTimer_timeout():
	# don't regen if shield is up
	if $Shield.is_active:
		return
	
	if  hp == max_hp:
		$HpRegenTimer.stop()

	gain_hp(hp_regen_amount)
	combatTextMngr.show_value(str("+", hp_regen_amount), position + Vector2(0, -50), null, Color('7893ff'))
