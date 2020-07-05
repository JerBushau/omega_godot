extends KinematicBody2D


onready var ship = get_parent()
var is_active = false
var on_cooldown = false
var pm = ParticleManager
var original_scale


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("activate_shield", self, "activate")
	Signals.connect("deactivate_shield", self, "deactivate")
	original_scale = scale


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
		Vector2(0,0), original_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
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
		original_scale, Vector2(0,0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, 0.2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	if not is_active:
		visible = false


func take_damage(_dmg, collision):
	ship.take_damage(2)
	pm.create_particle_of_type(Particle_Types.SHIELD_DMG, collision)


func _on_ShieldTimer_timeout():
#	deactivate()
	ship.take_damage(3)


func _on_ShieldCooldownTimer_timeout():
	on_cooldown = false
