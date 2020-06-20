class_name Ship
extends KinematicBody2D

export (int) var speed = 300
const DmgParticles = preload("res://Objects/ShipDmgParticles.tscn")
const Eblast = preload("res://Objects/Energy_blast.tscn")
onready var combatTextMngr = $"../Interface/CombatText"
const MAX_SPEED = 5
var velocity = Vector2()
export var max_hp = 150
export var shield = 100
export var friction = 0.001
export var acceleration = 0.01
var hp = max_hp
var is_dead = false

signal fire
signal damage_taken

func get_input():
	var input = Vector2()
	
	if is_dead:
		return input
	
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
# no up and down movement in original game
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	if Input.is_action_just_pressed('click'):
		$Weapon/ShotTimer.start()
		self.emit_signal('fire', global_rotation)
	if Input.is_action_just_released("click"):
		$Weapon/ShotTimer.stop()
	
	return input
	
	
func _process(_delta):
	if hp == max_hp:
		$HpRegenTimer.stop()
	if (hp <= 0 and not is_dead):
		is_dead = true
		$Sprite.visible = false
		$ShipDeathSprite.visible = true
		$AnimationPlayer.play("Death")
		$DeathExplosion.play()
		set_collision_layer(0)

	
func take_damage(dmg: int, collision):
	hp -= dmg
	$HpRegenTimer.stop()
	$HitTimer.start()
	emit_signal("damage_taken")
#	$Hit.play()
	var p = DmgParticles.instance()
	p.rotation = collision.angle
	p.set_emitting(true)
	p.position = collision.pos
	p.set_as_toplevel(true)
	add_child(p)

func _physics_process(_delta):
	position.x = clamp(position.x, $ShipCamera.limit_left+50, $ShipCamera.limit_right-50)
	position.y = clamp(position.y, $ShipCamera.limit_top+50, $ShipCamera.limit_bottom-50)
	
	var m_pos = get_global_mouse_position()
	var aim_speed = deg2rad(3)
	if get_angle_to(m_pos) > 0:
		rotation += aim_speed
	else:
		rotation -= aim_speed
#	look_at(get_global_mouse_position())
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)


func _on_ShotTimer_timeout():
	if not is_dead:
		self.emit_signal('fire', global_rotation)
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Death':
		$DeathTimer.start()
		$HitTimer.stop()
		$HpRegenTimer.stop()
		$ShipDeathSprite.visible = false
		visible = false
	pass # Replace with function body.


func _on_DeathTimer_timeout():
	queue_free()
	get_tree().change_scene("res://Levels/TitleScreen.tscn")


func _on_HitTimer_timeout():
	$HpRegenTimer.start()
	combatTextMngr.show_value("REGEN", position + Vector2(0, -50), null, Color('7893ff'))
	pass # Replace with function body.


func _on_HpRegenTimer_timeout():
	var amount = 2
	hp += amount
	combatTextMngr.show_value(str("+", amount), position + Vector2(0, -50), null, Color('7893ff'))
