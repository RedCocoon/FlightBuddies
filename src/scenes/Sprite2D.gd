extends Sprite2D

@export var names: Array[String]
@export_multiline var descs: Array[String]
@export var textures: Array[Texture2D]

@export var name_rtl: RichTextLabel
@export var desc_rtl: RichTextLabel
@export var sprite: Sprite2D

@export var flag: String
@export var min_index: int
@export var max_index: int

var index = 0

func _on_touch_screen_button_pressed():
	index += 1
	AudioManager.play("switch")
	load_data(index)

func load_data(ix):
	if ix > max_index:
		index = min_index
		ix = index
	if ix < min_index:
		index = max_index
		ix = index

	name_rtl.text = names[ix]
	if desc_rtl:
		desc_rtl.text = descs[ix]
	sprite.texture = textures[ix]
	
	GameData.set_data(flag, index)


func _on_touch_screen_button_2_pressed():
	index += 1
	AudioManager.play("switch")
	load_data(index)
