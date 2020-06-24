extends Node2D

const ship_dmg = preload("res://Objects/ShipDmgParticles.tscn")
const shield_dmg = preload("res://Objects/ShieldParticle.tscn")
const hedgelord_dmg = preload("res://Objects/HedgeHogSpineParticle.tscn")

const particles = {
	Particle_Types.SHIP_DMG: ship_dmg,
	Particle_Types.SHIELD_DMG: shield_dmg,
	Particle_Types.HEDGELORD_DMG: hedgelord_dmg,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_particle_of_type(type, collision=null):
	var p = particles[type].instance()
	p.rotation = collision.angle
	p.set_emitting(true)
	p.position = collision.pos
	p.set_as_toplevel(true)
	add_child(p)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
