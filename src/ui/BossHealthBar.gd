extends TextureProgressBar

@export var target: BaseEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	if not target:
		target = get_parent()
	max_value = target.MAX_HEALTH
	value = target.health
	target.health_changed.connect(_on_target_health_changed)

func _on_target_health_changed(new_health: float):
	value = new_health
