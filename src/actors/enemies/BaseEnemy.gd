extends Sprite2D
class_name BaseEnemy

@export var MAX_HEALTH : float = 100
@export var hit_radius : float = 8

var health : float
var dead : bool = false

signal health_changed(float)

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	health_changed.emit(health)
	BulletData.enemy_targets.append(self)

func hit(amount:float):
	if dead or GameData.game_finished:
		return
	health = max(0, health-amount)
	health_changed.emit(health)
	if health <= 0:
		die()

func die():
	dead = true
