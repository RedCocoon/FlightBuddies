extends Panel

@export var rtl: RichTextLabel

var template = "[center][{name}] has been defeated

Level Completed = 2500
Time Bonus = {time_left} x 10 = {time_mult}
Graze Bonus = {graze} / 10 = {graze_div}
Total = 2500 + {time_mult} + {graze_div} = {total}

{new_record_text}{new_char_text}[i][Double tap to continue]"

var new_char_text = "New Character Unlocked!\n"

func set_data(boss_name: String, time_remaining: int, graze: int):
	var time_mult = time_remaining * 10
	var graze_div = graze / 10
	var total = 2500 + time_mult + graze
	var has_character = GameData.data_has_key(boss_name)
	var new_record = total > GameData.get_data(boss_name, 0)
	if new_record:
		GameData.set_data(boss_name, total)
	var text = template.format({
		"name": boss_name,
		"time_left": time_remaining,
		"time_mult": time_mult,
		"graze": graze,
		"graze_div": graze_div,
		"new_record_text": "[color=gold]New Highest Score Get![color=white]\n" if new_record else "",
		"new_char_text": "" if has_character else "[color=gold]New Character Unlocked![color=white]\n",
		"total": total
	})
	rtl.text = text

func _input(event):
	if visible and event is InputEventScreenTouch:
		if event.double_tap:
			get_tree().change_scene_to_file("res://src/scenes/selection_scene.tscn")
