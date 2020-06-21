class_name Particle_Manager
extends Node2D

const ship_dmg = preload("res://Objects/ShipDmgParticles.tscn")
const shield_dmg = preload("res://Objects/ShieldParticle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_ship_dmg_particles(collision):
	var p = ship_dmg.instance()
	p.rotation = collision.angle
	p.set_emitting(true)
	p.position = collision.pos
	p.set_as_toplevel(true)
	add_child(p)
	
func create_shield_dmg_particles(collision):
	var p = shield_dmg.instance()
	p.rotation = collision.angle
	p.set_emitting(true)
	p.position = collision.pos
	p.set_as_toplevel(true)
	add_child(p)


func create_particle(type, collision=null):
	match(type):
		Particle_Types.SHIP_DMG:
			create_ship_dmg_particles(collision)
		Particle_Types.SHIELD_DMG:
			create_shield_dmg_particles(collision)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
