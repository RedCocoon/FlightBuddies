extends Control

@export var icons: Array[TextureRect]
@export var available_icon: Texture2D
@export var empty_icon: Texture2D

func set_display(count, max_count):
	for i in range(len(icons)):
		if i < count:
			icons[i].texture = available_icon
		elif i < max_count:
			icons[i].texture = empty_icon
		else:
			icons[i].visible = false
