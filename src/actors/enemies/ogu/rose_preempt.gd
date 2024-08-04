extends Sprite2D

var rose_life_modifier = 1

func _ready():
	AudioManager.play("fall", -10)

func _on_animation_player_animation_finished(anim_name):
	var bullet_holder = get_tree().get_first_node_in_group("BulletHolder")
	var rose_scene = load("res://src/actors/enemies/ogu/rose.tscn")
	var child = rose_scene.instantiate()
	bullet_holder.add_child(child)
	child.global_position = global_position
	child.rose_life_modifier = rose_life_modifier
	queue_free()
