extends Node

var game_finished = false
var graze = 0

func show_win_screen(boss_name: String):
	game_finished = true
	var timer = get_tree().get_first_node_in_group("Timer")
	var win_screen = get_tree().get_first_node_in_group("WinScreen")
	win_screen.set_data(boss_name, ceil(timer.time), graze)
	win_screen.show()

func show_timeout():
	game_finished = true
	var time_screen = get_tree().get_first_node_in_group("TimeOutScreen")
	time_screen.show()

func show_lose():
	game_finished = true
	var lose_screen = get_tree().get_first_node_in_group("LoseScreen")
	lose_screen.show()

func _input(event):
	if event is InputEventScreenTouch:
		if event.double_tap:
			get_tree().change_scene_to_file("res://src/scenes/selection_scene.tscn")
