extends Node2D


const Bullet = preload("res://Objects/Bullet.tscn")
onready var ship = get_parent()
var damage = 3
var crit_chance = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	ship.connect('fire', self, 'shoot')
	pass # Replace with function body.


func shoot(direction):
	var bullet = Bullet.instance()
	var is_crit = rand_range(0,100) <= crit_chance
	var final_dmg = damage
	
	if is_crit:
		final_dmg*=2
		
	bullet.init(final_dmg)
	bullet.is_crit = is_crit
	bullet.global_position = self.global_position
	bullet.linear_velocity = Vector2(cos(direction), sin(direction)).normalized() * bullet.speed
	bullet.velocity = bullet.linear_velocity
	bullet.global_rotation = direction
	bullet.set_as_toplevel(true)
	add_child(bullet)
	return true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
