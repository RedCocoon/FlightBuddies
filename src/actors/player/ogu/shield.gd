extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_rotation = 0
	for i in BulletData.bullets:
		var distance = i.global_position.distance_squared_to(global_position)
		if i.active and i.target_type == BulletData.TARGET_TYPES.PLAYER:
			if distance < 16 and (i.size.x * i.size.y) <= 64.0:
				AudioManager.play("bullet/shoot", 2)
				BulletData.deactivate_bullet(i)
			elif distance < 24:
				GameData.graze += 0.1
	for i in BulletData.enemy_targets:
		if i.global_position.distance_to(global_position) < (6+i.hit_radius):
			AudioManager.play("hit", -25)
			i.hit(0.25)
