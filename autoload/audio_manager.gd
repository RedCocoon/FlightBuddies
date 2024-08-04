extends Node

var available_asp = []

var variants = {
	"bullet/shoot_hard": [
		"bullet/shoot1",
		"bullet/shoot2",
		"bullet/shoot3",
		"bullet/shoot4",
	],
	"bullet/graze": [
		"bullet/graze1",
		"bullet/graze2",
		"bullet/graze3",
		"bullet/graze4",
	],
	"bullet/crunch": [
		"bullet/crunch1",
		"bullet/crunch2",
		"bullet/crunch3",
	],
	"hit": [
		"hit1",
		"hit2",
		"hit3",
		"hit4",
	]
}

func play(sound: String, volume_db: float = 1):
	var to_play = sound
	if variants.keys().has(to_play):
		to_play = variants[sound].pick_random()
	var s = load("res://assets/sfx/%s.ogg"%to_play)
	var asp
	if available_asp.is_empty():
		asp = AudioStreamPlayer.new()
		add_child(asp)
	else:
		asp = available_asp.pop_back()
	asp.volume_db = volume_db
	asp.stream = s
	asp.play()
	asp.finished.connect(kill_stream.bind(asp))
	return asp

func kill_stream(asp):
	if is_instance_valid(asp):
		available_asp.append(asp)

@onready var bgm_asp = AudioStreamPlayer.new()
func _ready():
	add_child(bgm_asp)

func play_bgm(file: String):
	if bgm_asp.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(bgm_asp, "volume_db", -15, 1)
		await tween.finished
	bgm_asp.stream = load("res://assets/sfx/bgm/%s.ogg"%file)
	bgm_asp.play()
	var tween = get_tree().create_tween()
	tween.tween_property(bgm_asp, "volume_db", 0, 1)
