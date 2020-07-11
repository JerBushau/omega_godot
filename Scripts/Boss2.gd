extends KinematicBody2D

signal growl_complete
signal level_end

enum states {
	FOLLOWING,
	HUNTING
}

const HUD = preload("res://Hedgehud.tscn")
const spitter = preload("res://Actors/Spitter/Spitter.tscn")
onready var combatTextMngr = $"../Interface/CombatText"
onready var bg_animation_player = $"../ParallaxBackground/AnimationPlayer"
var current_state = states.FOLLOWING
var max_hp = 1400
var speed = 200
var hp = max_hp
var is_dead = false
onready var player = $"../Ship"
var friction = 0.01
var acceleration = 0.029
var velocity = Vector2()
var is_attacking = false
var is_growling = false
var is_hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Enemies")
	var hud = HUD.instance()
	hud.setup("Boggy", [max_hp, hp], "boss2_hp_change")
	add_child(hud)
	$GrowlTimer.start()
	$AnimationPlayer.play("idle")


func cast_ray(pos):
	var space = get_world_2d().direct_space_state
	var result = space.intersect_ray(position, pos, [self], collision_mask)


func determine_state():
	match(current_state):
		states.FOLLOWING:
			current_state = states.HUNTING
		states.HUNTING:
			current_state = states.FOLLOWING
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	if is_dead:
		return
		
	var direction = Vector2.ZERO
	
	if is_instance_valid(player):
		match(current_state):
			states.FOLLOWING:
				is_attacking = false
				$GrowlTimer.wait_time = 3
				direction = follow()
			states.HUNTING:
				$GrowlTimer.wait_time = 6
				direction = hunt()
				is_attacking = true
		
		if direction.length() < 300 and current_state == states.HUNTING:
			acceleration += 0.2
			speed = 500
		
		if player.is_dead:
			speed = 90
			acceleration = 0.15
			direction = Vector2.UP
			aim(0)
		


	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)

	if is_growling:
		aim(0)
		velocity = velocity/2.5
	
	velocity = move_and_slide(velocity)


func hunt():
	speed = 275
	acceleration = 0.1
#	if not is_attacking:
#		$AnimationPlayer.play("attack")
	var rot_offset = player.global_position - global_position
	var angle = (rot_offset.normalized().angle())
	angle -= deg2rad(90)
	aim(angle)
	var direction = (player.position - position)
	return direction


func follow():
	speed = 100
	acceleration = 0.029
	aim(0)
	var direction = (player.position+Vector2(1, -400) - position)
	return direction


func spawn_spitter():
	if is_dead:
		return
		
	var s = spitter.instance()
	s.setup(global_position)
	get_parent().add_child(s)


func die():
	is_dead = true
	Signals.emit_signal("level_over", "win")
	$Tween.interpolate_property(self, "scale", scale, scale*2, 0.2)
	$Tween.interpolate_property(self, "modulate:a", modulate.a, 0.5, 0.2)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	ParticleManager.create_particle_of_type(Particle_Types.BOSS2_DEATH, { "vel": velocity.angle(), "pos": global_position, "angle": global_rotation })
	$Tween.interpolate_property(self, "modulate:a", modulate.a, 0, 0.2)
	$Tween.start()
	$Sprite.visible = false
	$Area2D/CollisionShape2D.disabled = true
	$CollisionPolygon2D.disabled = true
	$Timer.start()
	bg_animation_player.play("calm")
	

func take_damage(dmg, crit=false, collision=null):
	var new_hp = hp - dmg
	update_hp(new_hp)
	
	if not is_dead:
		combatTextMngr.show_value(str(dmg), position + Vector2(0, -75), crit)
	
	if is_hit:
		return
		
	is_hit = true
	var original_scale = Vector2(1,1)
	$Tween2.interpolate_property(self, "scale", scale, scale*1.05, 0.035)
	$Tween2.start()
	yield($Tween2, "tween_all_completed")
	if collision:
		ParticleManager.create_particle_of_type(Particle_Types.BOSS2_DMG, collision)
	$Tween2.interpolate_property(self, "scale", scale, original_scale, 0.035)
	$Tween2.start()
	yield($Tween2, "tween_all_completed")
	is_hit = false


func update_hp(new_hp):
	if is_dead:
		return
		
	hp = new_hp
	if hp <= 0 and not is_dead:
		die()
	if hp < 0:
		hp = 0
	Signals.emit_signal("boss2_hp_change", hp)
	

func growl():
	is_growling = true
	$AnimationPlayer.play("growl")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	is_growling = false
	determine_state()
	$GrowlTimer.start()
	emit_signal("growl_complete")


func aim(new_rot):
#	rotation = new_rot
	if not is_dead:
		$Tween.interpolate_property(self, "rotation", rotation, new_rot, 0.08)
		$Tween.start()

func go_for_grab(body):
	is_attacking = true
	z_index = 2
	var dmg = body.hp
	if body.name == "ship":
		dmg = body.hp/2
	body.take_damage(dmg)
	$AnimationPlayer.play("eat")
	yield($AnimationPlayer, "animation_finished")
	if not is_instance_valid(body):
		return
	if not is_growling and "Drone" in body.name:
		growl()
		yield(self, "growl_complete")
	$AnimationPlayer.play("idle")
	is_attacking = false
	velocity = Vector2.ZERO


func _on_GrowlTimer_timeout():
	growl()


func _on_Area2D_body_entered(body):
	if body != self and "hp" in body and not is_dead:
		go_for_grab(body)


func _on_Timer_timeout():
	emit_signal("level_end", true)


func _on_SpawnTimer_timeout():
	if current_state == states.FOLLOWING:
		spawn_spitter()
