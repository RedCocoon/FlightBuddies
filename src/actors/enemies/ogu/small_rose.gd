extends Bullet

func _on_timer_timeout():
	if not active:
		return
	AudioManager.play("bullet/shoot_hard")
	for i in range(4):
		BulletData.summon_bullet(global_position, (i*PI/2.0), BulletData.BULLET_TYPES.OGU_SMALL)
	BulletData.deactivate_bullet(self)
