extends CanvasLayer


#onready var ship = get_parent()
var _parent

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("activate_shield", self, "shield_on")
	Signals.connect("deactivate_shield", self, "shield_off")
	Signals.connect("release_ship_drones", self, "drones_out")
	Signals.connect("ship_hp_change", self, "update_hp_bar")
	Signals.connect("drone_cd_up", self, "drones_done")


func init(parent):
	_parent = parent
	$HpBar.max_value = _parent.max_hp
	$HpBar.value = _parent.hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$DroneAbility/ProgressBar.max_value = _parent.get_node("Drones/Cooldown").wait_time
	$DroneAbility/ProgressBar.value = _parent.get_node("Drones/Cooldown").time_left


func update_hp_bar(hp):
	$HpBar.value = hp


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
