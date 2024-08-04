extends Node2D

@export var health_counter: Control
@export var bomb_counter: Control
@export var boss_pos_mimic: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_holder = get_tree().get_first_node_in_group("PlayerHolder")
	var boss_holder = get_tree().get_first_node_in_group("BossHolder")
	var scene_to_load
	match int(GameData.get_data("selected_character", 0)):
		0:
			scene_to_load = preload("res://src/actors/player/tappy/tappy.tscn")
		1:
			scene_to_load = preload("res://src/actors/player/bam/bam.tscn")
		2:
			scene_to_load = preload("res://src/actors/player/ogu/ogu.tscn")
		3:
			scene_to_load = load("res://src/actors/player/tappy/tappy.tscn")
	var player = scene_to_load.instantiate()
	player_holder.add_child(player)
	player.global_position = player_holder.global_position
	player.bomb_used.connect(bomb_counter.set_display)
	player.health_changed.connect(health_counter.set_display.bind(3))
	match int(GameData.get_data("selected_boss", 0)):
		0:
			scene_to_load = load("res://src/actors/enemies/bam/bam.tscn")
		1:
			scene_to_load = preload("res://src/actors/enemies/bam/bam.tscn")
		2:
			scene_to_load = preload("res://src/actors/enemies/ogu/ogu.tscn")
		3:
			scene_to_load = load("res://src/actors/enemies/tappy/tappy.tscn")
	var boss = scene_to_load.instantiate()
	boss_holder.add_child(boss)
	boss.global_position = boss_holder.global_position
	
	boss_pos_mimic.fetch_boss()
	
	BulletData.generate_bullets()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
