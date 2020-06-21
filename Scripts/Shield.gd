extends KinematicBody2D


onready var ship = get_parent()
const shield_dmg = preload("res://Objects/ShieldParticle.tscn")
var is_active = false
var on_cooldown = false


# Called when the node enters the scene tree for the first time.
func _ready():
	ship.connect("activate_shield", self, "activate")
	ship.connect("deactivate_shield", self, "deactivate")


func activate():
	if is_active:
		return
	visible = true
	on_cooldown = true
	is_active = true
	$CollisionShape2D.disabled = false
	$ShieldTimer.start()
	$ShieldCooldownTimer.start()
	$Tween.interpolate_property(self, "scale",
		Vector2(0,0), Vector2(1,1), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(self, "modulate:a",
		0.0, 1.0, 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func deactivate():
	is_active = false
	$ShieldTimer.stop()
	$CollisionShape2D.disabled = true
	$Tween.interpolate_property(self, "scale",
		Vector2(1,1), Vector2(0,0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	if not is_active:
		visible = false


func consume(collision):
	ship.take_damage(2)
	var p = shield_dmg.instance()
	p.rotation = collision.angle
	p.set_emitting(true)
	p.position = collision.pos
	p.set_as_toplevel(true)
	add_child(p)

func _on_ShieldTimer_timeout():
#	deactivate()
	print('dmg: ' + str(3))
	ship.take_damage(3)
	print(ship.hp)
	


func _on_ShieldCooldownTimer_timeout():
	on_cooldown = false
