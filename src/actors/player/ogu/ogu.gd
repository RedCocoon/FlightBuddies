extends BasePlayer

var MAX_DELAY = 0.1
var delay = MAX_DELAY

@export var orbiter: Node2D
@export var shields: Array[Node2D]
@export var animp: AnimationPlayer

func _ready():
	MAX_BOMB = 1
	bomb = MAX_BOMB
	await get_tree().process_frame
	bomb_used.emit(bomb, MAX_BOMB)

func tick(delta):
	if delay > 0:
		delay -= delta
		return
	#if Input.is_action_pressed("shoot") or tracking:
		#delay = MAX_DELAY
		#for i in shields:
			#BulletData.summon_bullet(i.global_position+Vector2(2, 0), (PI/2), BulletData.BULLET_TYPES.MEDIUM_BLUE)

func activate_bomb():
	super()
	orbiter.bonus_time = 2
	invulnerable = true
	animp.play("Fade In")
	await get_tree().create_timer(2).timeout
	invulnerable = false
