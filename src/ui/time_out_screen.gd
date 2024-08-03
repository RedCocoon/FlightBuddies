extends Panel

func _input(event):
	if visible and event is InputEventScreenTouch:
		if event.double_tap:
			get_tree().change_scene_to_file("res://src/scenes/selection_scene.tscn")
