extends Sprite2D

func _ready():
	pass

func _on_animation_player_animation_finished(anim_name):
	var bullet_holder = get_tree().get_first_node_in_group("BulletHolder")
	var rose_scene = load("res://src/actors/enemies/ogu/rose.tscn")
	var child = rose_scene.instantiate()
	bullet_holder.add_child(child)
	child.global_position = global_position
	queue_free()
