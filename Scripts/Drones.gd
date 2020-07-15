extends Node2D

const drone = preload("res://Actors/DroneShip/DroneShip.tscn")
onready var ship = $"../"
onready var lvl_scene = $"../.."

var drone_count = 5
var on_cooldown = false
var timers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("release_ship_drones", self, "release_drone")


func _process(_delta):
	if drone_count >= 5 and not $ReleaseTimer.is_stopped():
		$ReleaseTimer.stop()
		$"../AnimationPlayer".play_backwards("open")


func drones_on():
	if on_cooldown:
		return 
	$"../AnimationPlayer".play("open")
	on_cooldown = true
	$ReleaseTimer.start()
	$Cooldown.start()


func release_drone():
	print(on_cooldown)
	if on_cooldown:
		return

	if drone_count > 0:
		$"../AnimationPlayer".play("open")
		yield($"../AnimationPlayer", "animation_finished")
		$"../AnimationPlayer".play_backwards("open")
		drone_count -= 1
		var d = drone.instance()
		d.init(ship.position)
		lvl_scene.add_child(d)
		$Cooldown.start()
		on_cooldown = true
		var timer = Timer.new()
		timer.connect("timeout",self,"_on_timer_timeout")
		timer.one_shot = true
		timer.wait_time = 6
		timers.append(timer)

		#timeout is what says in docs, in signals
		#self is who respond to the callback
		#_on_timer_timeout is the callback, can have any name
		add_child(timer) #to process
		timer.start() #to start


func _on_ReleaseTimer_timeout():
	release_drone()


func _on_Cooldown_timeout():
	on_cooldown = false
#	if drone_count < 5:
#		drone_count += 1

func _on_timer_timeout():
	var finished_timer = timers.pop_front()
	finished_timer.queue_free()
	print(timers)
	if drone_count < 5:
		drone_count += 1
	
	if drone_count == 5:
		Signals.emit_signal("drone_cd_up")
#		Signals.emit_signal("drone_cd_up")
