extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hedgelord = $"../../" 

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = hedgelord.hp
	value = hedgelord.hp
	Signals.connect('hedge_damage_taken', self, 'update_hp')
	pass # Replace with function body.


func update_hp(hp):
	value = hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
