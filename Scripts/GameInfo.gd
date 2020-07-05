extends Node


enum bosses {
	HEDGELORD,
	BOSS2
}

var player_state = {
	"hp": 150,
	"shield": 100,
	
}

var current_lv = ""
var next_lv = ""
var win = false

# current level
var current_boss = bosses.HEDGELORD

# level over stuff
var game_over_message = ""

# trans stuff
var trans_data = {
	"lv1": "Now entering Hedgelord space...",
	"lv2": "Now entering Boggy space...",
	"active": ""
}

var scenes = {
	"title": "TitleScreen",
	"trans": "TransScene",
	"go": "GameOver",
	"lv1": "Level1",
	"lv2": "Level2",
	"current": "",
	"next": ""
}


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("level_over", self, "handle_level_over")
	Signals.connect("pause", self, "handle_pause")
	Signals.connect("trans_complete", self, "change_to_next_scene")
	Signals.connect("fade_complete", self, "handle_fade_complete")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func handle_fade_complete(who):
	match(who):
		"title":
			start_level("lv1")
			return
		"lv1":
			change_to_next_scene()
			return
		"lv2":
			change_to_next_scene()
			return
		"go":
			if win:
				start_level(next_lv)
			else:
				start_level("title")
				

func set_level(current_lv):
	match(current_lv):
		"lv1":
			trans_data.active = trans_data.lv2
			current_lv = "lv1"
			next_lv = "lv2"
		"lv2":
			current_lv = "lv2"
			next_lv = "title"
		"title":
			trans_data.active = trans_data.lv1
			current_lv = "title"
			next_lv = "lv1"


func start_level(lv):
	win = false
	set_level(current_lv)
	change_to(scenes.trans)


func change_to(scene):
	scenes.current = scene
	get_tree().change_scene("res://Levels/{scene}.tscn".format({ "scene": scene }))


func change_to_next_scene():
	print(scenes.next)
	change_to(scenes.next)
	scenes.current = scenes.next
	scenes.next = scenes.go


func handle_pause(is_paused):
	get_tree().paused = is_paused


func handle_level_over(winOrLose):
	match (winOrLose):
		"win":
			you_win()
		"lose":
			you_lose()


func you_lose():
	win = false
	scenes.next = scenes.go
	game_over_message = "YOU DIED"


func you_win():
	win = true
	scenes.next = scenes.go
	game_over_message = "YOU WIN"


func set_boss(boss):
	current_boss = boss


func title_to_trans():
	start_level("lv1")


func trans_to_lv(lv):
	
