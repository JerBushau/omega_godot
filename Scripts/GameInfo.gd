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
	"active": "",
	"to": ""
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
	print("current scene ", scenes.current)
	match(who):
		"title":
			print('handle_fade: title')
			start_level("lv1")
			return
		"trans":
			# trans always -> level
			# so here, need to find out what lvl to trans into
			print('handle_fade: trans')
			change_to(trans_data.to)
			return
		"go":
			# game over always -> trans or title
			print('handle_fade: go')
			if win and current_lv == "lv2":
				print('yes')
				change_to(scenes.title)
			elif win:
				start_level(next_lv)
			else:
				change_to(scenes.title)
		_:
			# always trans -> level -> gameover
			change_to_next_scene()
			pass
	print(scenes.current)


func config_trans(lv):
	trans_data.active = trans_data[lv]
	trans_data.to = scenes[lv]
	
	if lv == "lv1":
		current_lv = lv
		next_lv = "lv2"
	elif lv == "lv2":
		current_lv = lv
		next_lv = "FIN"
		scenes.next = scenes.title


func start_level(lv):
	print("starting lv {lvl}".format({"lvl": lv}))
	win = false
	config_trans(lv)
	change_to(scenes.trans)


func change_to(scene):
	print("change to", scene)
	scenes.current = scene
	get_tree().change_scene("res://Levels/{scene}.tscn".format({ "scene": scene }))


func change_to_next_scene():
	print("change to next")
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
	pass	
