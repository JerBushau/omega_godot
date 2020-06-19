extends RigidBody2D

var speed = 600
var direction = Vector2()
var velocity = Vector2()
var dmg = 3
var collision_pos
var collision_angle
var collision_velocity_at_angle
var is_crit = false

func init(wep_dmg):
	dmg += wep_dmg

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		collision_pos = state.get_contact_collider_position(0)
		collision_angle = state.get_contact_local_normal(0).angle()
		collision_velocity_at_angle = state.get_contact_collider_velocity_at_position(0)


func _on_Bullet_body_entered(body):
	if (body.has_method('take_damage')):
		var collision_obj = { "vel": collision_velocity_at_angle, "pos": collision_pos, "angle": collision_angle }
		body.take_damage(dmg, is_crit, collision_obj)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
