extends BasePlayer

var MAX_DELAY = 0.1
var delay = MAX_DELAY

@export var ulti_player : AnimationPlayer

func activate_bomb():
	get_tree().paused = true
	invulnerable = true
	var affected_bullets = []
	var big_bullet = BulletData.summon_bullet(global_position, (PI/2), BulletData.BULLET_TYPES.BAM_BLUE_GIANT)
	big_bullet.scale = Vector2.ZERO
	var max_wait_time = 0
	ulti_player.play("Fade In")
	for i: Bullet in BulletData.bullets:
		var distance = i.global_position.distance_to(global_position)
		if i.target_type == BulletData.TARGET_TYPES.PLAYER and distance < 64:
			var tween = get_tree().create_tween()
			var scaled_distance = distance/64.0
			tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(i, "global_position", global_position, scaled_distance)
			tween.finished.connect(scale_big_bullet.bind(big_bullet, i.damage))
			if scaled_distance > max_wait_time:
				max_wait_time = scaled_distance
			affected_bullets.append(i)
	await ulti_player.animation_finished
	for i in affected_bullets:
		BulletData.deactivate_bullet(i)
	get_tree().paused = false
	invulnerable = false

func scale_big_bullet(big_bullet : Bullet, amount):
	big_bullet.scale.x += amount / 20.0
	big_bullet.scale.y += amount / 20.0
	big_bullet.scale = big_bullet.scale.clamp(Vector2(0.25, 0.25), Vector2(3, 3))
	big_bullet.damage += amount / 10.0
	big_bullet.damage = min(big_bullet.damage, 100)

func tick(delta):
	if delay > 0:
		delay -= delta
		return
	if Input.is_action_pressed("shoot") or tracking:
		delay = MAX_DELAY
		for i in range(-5, 5):
			BulletData.summon_bullet(global_position, (PI/2)+(i*deg_to_rad(5)), BulletData.BULLET_TYPES.SMALL_BLUE_BAM)
