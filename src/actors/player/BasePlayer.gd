extends Sprite2D
class_name BasePlayer



var relative_position = Vector2.ZERO
var tracking = false

var health = 3
var bomb = 3

var invulnerable = false


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
			global_position = get_global_from_screen(event.position) + relative_position

func get_global_from_screen(screen_pos):
	return (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * screen_pos

func hit(_amount):
	if GameData.game_finished or invulnerable:
		return
	health -= 1
	bomb = 3
	activate_bomb()
	if health < 0:
		GameData.show_lose()

func activate_bomb():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameData.game_finished:
		return
	
	tick(delta)

func tick(_delta):
	pass
