extends Line2D

@export var area: Area2D
@onready var player = get_tree().get_first_node_in_group("Player")

var hit_cd = 0

func _ready():
	var twe = get_tree().create_tween()
	twe.tween_property(self, "scale", Vector2(0, 1), 5.0)
	await get_tree().create_timer(4.5).timeout
	hit_cd = INF

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit_cd <= 0 and is_point_in_area(player.global_position):
		player.hit(1)
		hit_cd = 0.5
	elif hit_cd > 0:
		hit_cd -= delta

func add_rose():
	var rose_scene = load("res://src/actors/enemies/ogu/rose.tscn")
	var child = rose_scene.instantiate()
	child.position = Vector2(0, randf_range(-100, 100))
	add_child(child)

func is_point_in_area(pos: Vector2):
	var query := PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.position = pos
	var result := get_world_2d().direct_space_state.intersect_point(query)
	for entry in result:
		print(entry)
		if entry.collider == area:
			return true
	return false

