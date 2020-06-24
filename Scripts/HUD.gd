extends CanvasLayer


onready var ship = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("activate_shield", self, "shield_on")
	Signals.connect("deactivate_shield", self, "shield_off")
	Signals.connect("release_ship_drones", self, "drones_out")
	
	$HpBar.max_value = ship.max_hp
	$HpBar.value = ship.max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HpBar.value = ship.hp
	$DroneAbility/ProgressBar.max_value = $"../Drones/Cooldown".wait_time
	$DroneAbility/ProgressBar.value = $"../Drones/Cooldown".time_left


func drones_out():
	activate_button($DroneAbility)
	$DroneAbility/ProgressBar.visible = true


func activate_button(button):
	button.self_modulate = Color(0.8, 0.8, 0.8, 1)


func deactivate_button(button):
	button.self_modulate = Color(1.4, 1.4, 1.4, 1)


func shield_off():
	deactivate_button($ShieldAbility)
	$ShieldAbility/AnimationPlayer.stop()


func shield_on():
	activate_button($ShieldAbility)
	$ShieldAbility/AnimationPlayer.play("Active")
	

func _on_Cooldown_timeout():
	deactivate_button($DroneAbility)
	$DroneAbility/ProgressBar.visible = false
