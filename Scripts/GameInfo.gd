extends Node


enum bosses {
	HEDGELORD
}


var current_boss = bosses.HEDGELORD
var game_over_message = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("level_over", self, "handle_level_over")
	Signals.connect("pause", self, "handle_pause")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func handle_pause(is_paused):
	get_tree().paused = is_paused


func handle_level_over(winOrLose):
	match (winOrLose):
		"win":
			you_win()
		"lose":
			you_lose()


func you_lose():
	game_over_message = "YOU DIED"


func you_win():
	game_over_message = "YOU WIN"


func set_boss(boss):
	current_boss = boss
