extends Node2D

@export var charac: Node2D
@export var boss: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_bgm("title")

func _on_touch_screen_button_3_pressed():
	AudioManager.play("confirm")
	GameData.set_data("selected_character", charac.index)
	GameData.set_data("selected_boss", boss.index)
	get_tree().change_scene_to_file("res://src/scenes/game_scene.tscn")
