extends Sprite2D

@export var LEVEL_BOUND : CollisionShape2D
@export var normal_shoot_pos_marker : Array[Marker2D]
@export var focus_shoot_pos_marker : Array[Marker2D]
@export var shoot_pos_indicator : Array[Sprite2D]

@export_category("Character Stats")
@export var SPEED : float = 45.0
@export var FOCUS_SPEED : float = 10.0
@export var MAX_SHOOT_DELAY : float = 0.1
@export var PRIMARY_BULLET : BulletData.BULLET_TYPES
@export var SECONDARY_BULLET : BulletData.BULLET_TYPES

@export_category("Ultimate Anim Players")
@export var tapir_stomp_anim_player: AnimationPlayer

var focus_delta = 0
var shoot_delay = MAX_SHOOT_DELAY

var relative_position = Vector2.ZERO
var tracking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not LEVEL_BOUND:
		LEVEL_BOUND = get_tree().get_first_node_in_group("LevelBound")
	for i in range(len(shoot_pos_indicator)):
		shoot_pos_indicator[i].global_position = normal_shoot_pos_marker[i].global_position

func _input(event):
	if GameData.game_finished:
		return
	if event is InputEventScreenTouch:
		if event.pressed and not tracking:
			relative_position = global_position - get_global_from_screen(event.position)
			tracking = true
		else:
			relative_position = Vector2.ZERO
			tracking = false
		if event.double_tap:
			get_tree().paused = true
			tapir_stomp_anim_player.play("Fade In")
			await get_tree().create_timer(0.8).timeout
			for i in BulletData.bullets:
				if i.active:
					BulletData.deactivate_bullet(i)
			get_tree().paused = false	
	if event is InputEventScreenDrag:
		if tracking:
			global_position = get_global_from_screen(event.position) + relative_position

func get_global_from_screen(screen_pos):
	return (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * screen_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameData.game_finished:
		return
	
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
	
	if Input.is_action_pressed("shoot") or Input.is_action_pressed("focus") or tracking:
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
