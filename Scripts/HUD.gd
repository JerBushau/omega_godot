extends CanvasLayer


# on init, set the 'parent' but doesn't actually need to be the parent. 
# rather needs to be entity with HP and such we wanna track
var _parent

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("activate_shield", self, "shield_on")
	Signals.connect("deactivate_shield", self, "shield_off")
	Signals.connect("release_ship_drones", self, "drones_out")
	_parent.connect("update_hp", self, "update_hp_bar")
	Signals.connect("drone_cd_up", self, "drones_done")


func init(parent):
	_parent = parent
	$HpBar.max_value = _parent.max_hp
	$HpBar.value = _parent.hp
	$ProgressBar.max_value = _parent.speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$DroneAbility/ProgressBar.max_value = _parent.get_node("Drones/Cooldown").wait_time
	$DroneAbility/ProgressBar.value = _parent.get_node("Drones/Cooldown").time_left
	$ProgressBar.value = _parent.velocity.length()


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


func _on_ProgressBar_value_changed(value):
#	$Tween.interpolate_method($ProgressBar.get("custom_styles/fg"), "set_bg_color", Color("0081ff"), Color("ffffff"), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$Tween.start()
	var r = range_lerp(value, 0, 100, 0, 1)
	var g = range_lerp(value, 0, _parent.speed, 1, 0)
	var color = Color(r, g, 0)
	$ProgressBar.get("custom_styles/fg").set_bg_color(color)


func _on_Tween_tween_step(object, key, elapsed, value):
	$ProgressBar.update()
