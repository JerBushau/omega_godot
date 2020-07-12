extends Node

signal update_hp(hp)

var is_dead = false
var max_hp = 100
var hp = max_hp
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
	var prev_hp = hp
	lose_hp(dmg)
	
	if hp != prev_hp:
		emit_signal("update_hp", hp)


func lose_hp(hp_to_lose):
	var min_hp = 0
	var new_hp = hp - hp_to_lose
	hp = clamp(new_hp, min_hp, max_hp)


func gain_hp(hp_to_gain):
	var min_hp = 0
	var new_hp = hp + hp_to_gain
	hp = clamp(new_hp, min_hp, max_hp)
