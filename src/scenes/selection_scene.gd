extends Node2D

@export var charac: Node2D
@export var boss: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_bgm("title")
	charac.index = int(GameData.get_data("selected_character", 0))
	charac.load_data(charac.index)
	boss.index = int(GameData.get_data("selected_boss", 0))
	boss.load_data(boss.index)

func _on_touch_screen_button_3_pressed():
	AudioManager.play("confirm")
	GameData.game_finished = false
	get_tree().change_scene_to_file("res://src/scenes/game_scene.tscn")
