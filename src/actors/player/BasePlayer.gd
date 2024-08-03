extends Sprite2D

@export var SPEED : float = 45.0
@export var FOCUS_SPEED : float = 10.0
@export var MAX_SHOOT_DELAY : float = 0.1
@export var LEVEL_BOUND : CollisionShape2D
@export var normal_shoot_pos_marker : Array[Marker2D]
@export var focus_shoot_pos_marker : Array[Marker2D]
@export var shoot_pos_indicator : Array[Sprite2D]

var focus_delta = 0
var shoot_delay = MAX_SHOOT_DELAY

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(shoot_pos_indicator)):
		shoot_pos_indicator[i].global_position = normal_shoot_pos_marker[i].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	dir = Vector2.ZERO.direction_to(dir)
	global_position += dir * delta * SPEED * (0.5 if Input.is_action_pressed("focus") else 1)
	var bound = LEVEL_BOUND.get_shape().get_rect()
	global_position = global_position.clamp(bound.get_center() - (bound.size/2.0), bound.get_center() + (bound.size/2.0))
	
	if Input.is_action_pressed("focus"):
		focus_delta = min(1, focus_delta + (delta * FOCUS_SPEED))
	else:
		focus_delta = max(0, focus_delta - (delta * FOCUS_SPEED))
	if (focus_delta != 0 and focus_delta != 1):
		for i in range(len(shoot_pos_indicator)):
			var new_pos = lerp(normal_shoot_pos_marker[i].global_position, focus_shoot_pos_marker[i].global_position, focus_delta)
			shoot_pos_indicator[i].global_position = new_pos
	
	if Input.is_action_pressed("shoot") or Input.is_action_pressed("focus"):
		if shoot_delay > 0:
			shoot_delay -= delta
		else:
			shoot_delay = MAX_SHOOT_DELAY
			for i in range(len(shoot_pos_indicator)):
				if Input.is_action_pressed("focus") or i >= 2:
					var bullet: Bullet = BulletData.summon_bullet(shoot_pos_indicator[i].global_position, PI/2, BulletData.BULLET_TYPES.SMALL_BLUE)
					if not Input.is_action_pressed("focus"):
						bullet.track_type = BulletData.TRACK_TYPES.CONTINUOUS
				else:
					BulletData.summon_bullet(shoot_pos_indicator[i].global_position, PI/2, BulletData.BULLET_TYPES.MEDIUM_BLUE)
