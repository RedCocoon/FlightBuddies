extends Node2D

var boss
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss:
		global_position.x = boss.global_position.x

func fetch_boss():
	boss = get_tree().get_first_node_in_group("Boss")
