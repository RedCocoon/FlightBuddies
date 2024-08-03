extends Node

var bullet_count = 1000

var enemy_targets: Array[BaseEnemy] = []

enum BULLET_TYPES {
	SMALL_BLUE,
	MEDIUM_BLUE,
	BAM_MEDIUM,
	BAM_HEART,
	BAM_SHARD,
}

enum TARGET_TYPES {
	PLAYER,
	ENEMY
}

enum TRACK_TYPES {
	NONE,
	INITIAL,
	CONTINUOUS
}

var atlas_data = {
	BULLET_TYPES.SMALL_BLUE: {
		"pos": [0, 0],
		"speed": 100,
		"sprite_size": [4, 4],
		"target_type": TARGET_TYPES.ENEMY
	},
	BULLET_TYPES.MEDIUM_BLUE: {
		"pos": [1, 0],
		"speed": 100,
		"sprite_size": [4, 8],
		"target_type": TARGET_TYPES.ENEMY
	},
	BULLET_TYPES.BAM_MEDIUM: {
		"pos": [0, 1],
		"speed": 10,
		"sprite_size": [6, 6]
	},
	BULLET_TYPES.BAM_HEART: {
		"pos": [1, 1],
		"speed": 10,
		"sprite_size": [6, 6]
	},
	BULLET_TYPES.BAM_SHARD: {
		"pos": [2, 1],
		"size": [2, 1],
		"speed": 50,
		"track": TRACK_TYPES.INITIAL
	}
}

var inactive_bullets: Array = []

func get_bullet_data(type: BULLET_TYPES) -> Array:
	var data = atlas_data.get(type, {})
	var pos = data.get("pos", [0, 0])
	var size = data.get("size", [1, 1])
	var speed = data.get("speed", 10)
	var sprite_size = data.get("sprite_size", [size[0]*8, size[1]*8])
	var target_type = data.get("target_type", TARGET_TYPES.PLAYER)
	var damage = data.get("damage", 1)
	var track_type = data.get("track", TRACK_TYPES.NONE)
	return [Rect2i(pos[0]*8, pos[1]*8, size[0]*8, size[1]*8), speed, sprite_size, target_type, damage, track_type]
	

func _ready():
	generate_bullets()

func generate_bullets():
	var bullet_scene = load("res://src/actors/bullet.tscn")
	var bullet_holder = get_tree().get_first_node_in_group("BulletHolder")
	if not bullet_holder:
		return
	for i in range(bullet_count):
		var b = bullet_scene.instantiate()
		bullet_holder.add_child(b)
		deactivate_bullet(b)
		#b.initiate(randi_range(0, BULLET_TYPES.size()-1))

func summon_bullet(pos: Vector2, rot: float, type: BULLET_TYPES) -> Bullet:
	var b = inactive_bullets.pop_back()
	if b == null:
		return
	#b.initiate(randi_range(0, BULLET_TYPES.size()-1))
	b.initiate(type)
	b.global_position = pos
	b.faux_rotation = rot
	return b

func deactivate_bullet(bullet: Bullet):
	bullet.active = false
	inactive_bullets.append(bullet)
	bullet.global_position = Vector2(-999, -999)
