class_name BaseActor
extends KinematicBody2D

signal update_hp(hp)

var is_dead = false
var max_hp = 100
var hp = 0
var speed = 100
var velocity = Vector2.ZERO
var acceleration = 0.01
var friction = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func take_damage(dmg):
	lose_hp(dmg)


func lose_hp(hp_to_lose):
	var new_hp = hp - hp_to_lose
	_set_hp(new_hp)


func gain_hp(hp_to_gain):
	var new_hp = hp + hp_to_gain
	_set_hp(new_hp)


func _set_hp(new_hp):
	# maybe signal should be setup/emitted by actor itself and not base..?
	var prev_hp = hp
	var min_hp = 0
	hp = clamp(new_hp, min_hp, max_hp)
	
	if hp != prev_hp:
		emit_signal("update_hp", hp)


func move(direction):
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
