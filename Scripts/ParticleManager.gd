extends Node2D

const ship_dmg = preload("res://Objects/ShipDmgParticles.tscn")
const shield_dmg = preload("res://Objects/ShieldParticle.tscn")
const hedgelord_dmg = preload("res://Objects/HedgeHogSpineParticle.tscn")
const boss2_explosion = preload("res://Objects/Boss2Explosion.tscn")
const boss2_dmg = preload("res://Objects/Boss2DmgParticles.tscn")
const spitter_spit = preload("res://Objects/SpitterProjectileParticles.tscn")


const particles = {
	Particle_Types.SHIP_DMG: ship_dmg,
	Particle_Types.SHIELD_DMG: shield_dmg,
	Particle_Types.HEDGELORD_DMG: hedgelord_dmg,
	Particle_Types.BOSS2_DEATH: boss2_explosion,
	Particle_Types.BOSS2_DMG: boss2_dmg,
	Particle_Types.SPITTER_SPIT: spitter_spit
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
