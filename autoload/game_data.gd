extends Node

var game_finished = false
var graze = 0 :
	set(g):
		if game_finished:
			return
		graze = g
		AudioManager.play("bullet/graze")
		graze_changed.emit(g)

var permanent_data : Dictionary = {}

signal graze_changed(int)

func _ready():
	load_data()

func save_data():
	var file = FileAccess.open("user://data.cocoon", FileAccess.WRITE)
	file.store_string(JSON.stringify(permanent_data))
	file.close()

func set_data(key, value):
	permanent_data[key] = value
	save_data()

func data_has_key(key):
	return permanent_data.keys().has(key)

func get_data(key, default):
	return permanent_data.get(key, default)

func load_data():
	if not FileAccess.file_exists("user://data.cocoon"):
		save_data()
		return
	var file = FileAccess.open("user://data.cocoon", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	permanent_data = data
	
func show_win_screen(boss_name: String):
	
	game_finished = true
	var timer = get_tree().get_first_node_in_group("Timer")
	var win_screen = get_tree().get_first_node_in_group("WinScreen")
	win_screen.set_data(boss_name, ceili(timer.time), ceili(graze))
	win_screen.show()

func show_timeout():
	AudioManager.play("gameover")
	game_finished = true
	var time_screen = get_tree().get_first_node_in_group("TimeOutScreen")
	time_screen.show()

func show_lose():
	AudioManager.play("gameover")
	game_finished = true
	var lose_screen = get_tree().get_first_node_in_group("LoseScreen")
	lose_screen.show()
