extends Line2D

var new_parent

func _ready():
	AudioManager.play("fall", -10)
	await get_tree().create_timer(1.0).timeout
	var laser_scene = load("res://src/actors/enemies/biggie/laser.tscn")
	var child = laser_scene.instantiate()
	new_parent.add_child(child)
	child.global_position = new_parent.global_position
	queue_free()
