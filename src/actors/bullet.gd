extends Sprite2D
class_name Bullet

var delay : float = 0
var speed : float = 0
var faux_rotation : float
var hit_distance : Vector2 = Vector2.ZERO
var graze_distance : Vector2 = Vector2.ZERO
var active : bool = false
var damage : float = 1
var target_type: BulletData.TARGET_TYPES = BulletData.TARGET_TYPES.PLAYER
var track_type: BulletData.TRACK_TYPES = BulletData.TRACK_TYPES.NONE
static var level_bound : Rect2
static var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not faux_rotation:
		faux_rotation = randf_range(PI, -PI)
	if not level_bound:
		var bound : Rect2 = get_tree().get_first_node_in_group("LevelBound").get_shape().get_rect()
		level_bound = bound.grow(32)
	if not player:
		player = get_tree().get_first_node_in_group("Player")
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		return
	if not level_bound.has_point(global_position):
		BulletData.deactivate_bullet(self)
		return
	if delay > 0:
		delay -= delta
		if track_type == BulletData.TRACK_TYPES.INITIAL:
			rotation = player.global_position.angle_to_point(global_position)
		return
	if track_type == BulletData.TRACK_TYPES.CONTINUOUS:
		if target_type == BulletData.TARGET_TYPES.PLAYER:
			faux_rotation = 0
			rotation = player.global_position.angle_to_point(global_position)
		elif not BulletData.enemy_targets.is_empty():
			faux_rotation = 0
			rotation = BulletData.enemy_targets[0].global_position.angle_to_point(global_position)
	global_position += Vector2.LEFT.rotated(faux_rotation+rotation) * delta * speed
	if (target_type == BulletData.TARGET_TYPES.PLAYER and not player):
		return
	#var distance_squared_to_target = player.global_position.distance_squared_to(global_position)
	if target_type == BulletData.TARGET_TYPES.PLAYER:
		try_hit(player)
	else:
		for i in BulletData.enemy_targets:
			try_hit(i)

func try_hit(target: Node2D):
	var hit_correction = 0
	if target_type == BulletData.TARGET_TYPES.ENEMY:
		hit_correction = target.hit_radius
	var x_distance = abs(target.global_position.x - global_position.x) - hit_correction
	var y_distance = abs(target.global_position.y - global_position.y) - hit_correction
	if (x_distance < hit_distance.x and y_distance < hit_distance.y):
		if (target.has_method("hit")):
			target.hit(damage)
		BulletData.deactivate_bullet(self)
		return
	if target_type == BulletData.TARGET_TYPES.PLAYER:
		if (x_distance < graze_distance.x and y_distance <= graze_distance.y):
			print("Graze")

func initiate(type: BulletData.BULLET_TYPES):
	var data = BulletData.get_bullet_data(type)
	delay = 0
	rotation = 0
	region_rect = data[0]
	speed = data[1]
	target_type = data[3]
	damage = data[4]
	track_type = data[5]
	
	var sprite_size = data[2]
	if target_type == BulletData.TARGET_TYPES.PLAYER:
		hit_distance.x = sprite_size[0] / 4
		hit_distance.y = sprite_size[1] / 4
		graze_distance.x = sprite_size[0] + 2
		graze_distance.y = sprite_size[1] + 2
	else:
		hit_distance.x = sprite_size[0]
		hit_distance.y = sprite_size[1]
	active = true
