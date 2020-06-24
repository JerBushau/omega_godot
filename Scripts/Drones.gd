extends Node2D

const drone = preload("res://Actors/DroneShip.tscn")
onready var hedgelord = $"../../Hedgelord"
onready var ship = $"../"
onready var lvl_scene = $"../.."

var drone_count = 0
var on_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("release_ship_drones", self, "drones_on")


func _process(_delta):
	if drone_count >= 5:
		$ReleaseTimer.stop()


func drones_on():
	if on_cooldown:
		return 
	on_cooldown = true
	$ReleaseTimer.start()
	$Cooldown.start()


func release_drone():
	drone_count += 1
	var d = drone.instance()
	d.init(hedgelord, ship.position)
	lvl_scene.add_child(d)


func _on_ReleaseTimer_timeout():
	release_drone()


func _on_Cooldown_timeout():
	drone_count = 0
	on_cooldown = false
	Signals.emit_signal("drone_cd_up")
