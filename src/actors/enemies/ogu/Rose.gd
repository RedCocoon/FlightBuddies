extends BaseEnemy


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	MAX_HEALTH = 5
	health = 5
	hit_radius = 12

func die():
	super()
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Explode")
		await $AnimationPlayer.animation_finished
		for i in range(8):
			BulletData.summon_unique_bullet(global_position, (i*2*PI/8), BulletData.BULLET_TYPES.OGU_ROSE)
		for i in range(8):
			BulletData.summon_bullet(global_position, (i*2*PI/8)+(2*PI/16), BulletData.BULLET_TYPES.OGU_SMALL)
		BulletData.enemy_targets.erase(self)
		queue_free()
