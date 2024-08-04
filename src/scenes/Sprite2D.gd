extends Sprite2D

@export var names: Array[String]
@export_multiline var descs: Array[String]
@export var textures: Array[Texture2D]

@export var name_rtl: RichTextLabel
@export var desc_rtl: RichTextLabel
@export var sprite: Sprite2D

@export var flag: String

var index = 0

func _on_touch_screen_button_pressed():
	index += 1
	if index >= 4:
		index = 0
	AudioManager.play("switch")
	load_data(index)

func load_data(index):
	name_rtl.text = names[index]
	if desc_rtl:
		desc_rtl.text = descs[index]
	sprite.texture = textures[index]
	
	GameData.set_data(flag, index)


func _on_touch_screen_button_2_pressed():
	index += 1
	if index >= 4:
		index = 0
	AudioManager.play("switch")
	load_data(index)
