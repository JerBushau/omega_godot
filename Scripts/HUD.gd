extends CanvasLayer


onready var ship = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("activate_shield", self, "shield_on")
	Signals.connect("deactivate_shield", self, "shield_off")
	Signals.connect("release_ship_drones", self, "drones_out")
	Signals.connect("ship_hp_change", self, "update_hp_bar")
	Signals.connect("drone_cd_up", self, "drones_done")
	
	$HpBar.max_value = ship.max_hp
	$HpBar.value = ship.max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$DroneAbility/ProgressBar.max_value = $"../Drones/Cooldown".wait_time
	$DroneAbility/ProgressBar.value = $"../Drones/Cooldown".time_left


func update_hp_bar(hp):
	print(hp)
	$HpBar.value = ship.hp


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
	

func drones_done():
	deactivate_button($DroneAbility)
	$DroneAbility/ProgressBar.visible = false
