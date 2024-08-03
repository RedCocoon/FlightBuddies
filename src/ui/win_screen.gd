extends Panel

@export var rtl: RichTextLabel

var template = "[center][{name}] has been defeated

Level Completed = 2500
Time Bonus = {time_left} x 10 = {time_mult}
Graze Bonus = {graze} / 10 = {graze_div}
Total = 2500 + {time_mult} + {graze_div} = {total}

{new_char_text}[i][Double tap to continue]"

var new_char_text = "New Character Unlocked!\n"

func set_data(boss_name: String, time_remaining: int, graze: int):
	var time_mult = time_remaining * 10
	var graze_div = graze / 10
	var text = template.format({
		"name": boss_name,
		"time_left": time_remaining,
		"time_mult": time_mult,
		"graze": graze,
		"graze_div": graze_div,
		"new_char_text": "",
		"total": 2500 + time_mult + graze
	})
	rtl.text = text
