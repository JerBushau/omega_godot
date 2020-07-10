extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var parent = $"../../" 

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = parent.hp
	value = parent.hp
	Signals.connect('hedge_hp_change', self, 'update_hp')
	pass # Replace with function body.


func setup(values, signal_name):
	max_value = values[0]
	value = values[1]
	Signals.connect(signal_name, self, 'update_hp')


func update_hp(hp):
	value = hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
