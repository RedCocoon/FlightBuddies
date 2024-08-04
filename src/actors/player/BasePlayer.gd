extends Sprite2D
class_name BasePlayer



var relative_position = Vector2.ZERO
var tracking = false

var health = 3
var MAX_BOMB = 3
var bomb = MAX_BOMB

var invulnerable = false
@onready var level_bound: CollisionShape2D = get_tree().get_first_node_in_group("LevelBound")

signal bomb_used(count, max_count)
signal health_changed(float)

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
		if event.double_tap and bomb > 0:
			bomb -= 1
			activate_bomb()
	if event is InputEventScreenDrag:
		if tracking:
			var new_pos: Vector2 = (get_global_from_screen(event.position) + relative_position)
			var rect: Rect2 = level_bound.shape.get_rect()
			global_position = new_pos.clamp(rect.position, rect.position+(rect.size))

func get_global_from_screen(screen_pos):
	return (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * screen_pos

func hit(_amount):
	if GameData.game_finished or invulnerable:
		return
	health -= 1
	health_changed.emit(health)
	bomb = MAX_BOMB
	activate_bomb()
	if health < 0:
		GameData.show_lose()

func activate_bomb():
	bomb_used.emit(bomb, MAX_BOMB)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameData.game_finished:
		return
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	dir = Vector2.ZERO.direction_to(dir)
	global_position += dir * delta * 45.0 * (0.5 if Input.is_action_pressed("focus") else 1)
	tick(delta)

func tick(_delta):
	pass
