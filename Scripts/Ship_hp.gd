extends ProgressBar

onready var ship = $"../../"

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = ship.hp
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = ship.hp
