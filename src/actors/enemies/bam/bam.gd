extends BaseEnemy

@export var health_bar: TextureProgressBar
var MAX_LIVES = 8
var lives = MAX_LIVES
var anim_cycle_angle: float = 0
var MAX_HEART_DELAY = 1
var heart_delay = MAX_HEART_DELAY

var MAX_ATTACK_DELAY = 1
var attack_delay = MAX_HEART_DELAY

var available_attacks := []

enum ATTACKS {CRYSTAL_SHARDS, BURST, CRYSTAL_SHARDS_STAGERRED}

func _ready():
	super()
	AudioManager.play_bgm("vs_bam")
	health_bar.tint_under = Color("d87f5d")

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		hit(999)
	if lives != MAX_LIVES:
		heart_delay -= delta
		if heart_delay <= 0:
			heart_delay = MAX_HEART_DELAY
			for i in range(4):
				BulletData.summon_bullet(global_position, -anim_cycle_angle-(i*2*PI/4), BulletData.BULLET_TYPES.BAM_HEART)
			AudioManager.play("bullet/shoot_hard", 1)
				
	if attack_delay != -INF:
		attack_delay -= delta
		if attack_delay <= 0:
			attack_delay = -INF
			attack()
	else:
		wander(delta)

func wander(delta):
	anim_cycle_angle += delta
	if anim_cycle_angle > 2*PI:
		anim_cycle_angle = 0
	position.y = sin(anim_cycle_angle)
	position.x = cos(anim_cycle_angle)*10

func attack():
	if available_attacks.is_empty():
		return
	var chosen = available_attacks.pick_random()
	match chosen:
		ATTACKS.CRYSTAL_SHARDS:
			for i in range(8):
				var bullet = BulletData.summon_bullet(global_position+(16*Vector2.LEFT.rotated(i*2*PI/8.0)), 0, BulletData.BULLET_TYPES.BAM_SHARD)
				bullet.delay = 0.8 - (i/10.0)
				AudioManager.play("bullet/shoot_glass", 1)
				get_tree().create_timer(bullet.delay).timeout.connect(thonk)
				await get_tree().create_timer(0.1).timeout
			attack_delay = MAX_ATTACK_DELAY
		ATTACKS.BURST:
			for i in range(5):
				for j in range(5):
					BulletData.summon_bullet(global_position, (2*PI*j/5)+(i*0.1), BulletData.BULLET_TYPES.BAM_MEDIUM)
				AudioManager.play("bullet/shoot_hard", 1)
				await get_tree().create_timer(0.1).timeout
			attack_delay = MAX_ATTACK_DELAY
			heart_delay = MAX_HEART_DELAY
		ATTACKS.CRYSTAL_SHARDS_STAGERRED:
			for i in range(8):
				var bullet = BulletData.summon_bullet(global_position+(16*Vector2.LEFT.rotated(i*2*PI/8.0)), 0, BulletData.BULLET_TYPES.BAM_SHARD)
				bullet.delay = 0.3
				AudioManager.play("bullet/shoot_glass", -5)
				get_tree().create_timer(0.3).timeout.connect(thonk)
				await get_tree().create_timer(0.1).timeout
			attack_delay = MAX_ATTACK_DELAY

func thonk():
	AudioManager.play("bullet/glass_thonk")

func die():
	dead = true
	lives -= 1
	if MAX_LIVES-lives > 1 and not ATTACKS.CRYSTAL_SHARDS in available_attacks:
		available_attacks.append(ATTACKS.CRYSTAL_SHARDS)
	if MAX_LIVES-lives > 3 and not ATTACKS.BURST in available_attacks:
		available_attacks.append(ATTACKS.BURST)
	if MAX_LIVES-lives > 5 and not ATTACKS.CRYSTAL_SHARDS_STAGERRED in available_attacks:
		available_attacks.append(ATTACKS.CRYSTAL_SHARDS_STAGERRED)
		
	if lives <= 0:
		GameData.show_win_screen("Bam")
		return
	AudioManager.play("forcefield")
	await get_tree().create_timer(0.2).timeout
	health = MAX_HEALTH
	if lives <= 1:
		health_bar.tint_under = Color("280722")
	dead = false
	for i in range(13):
		for j in range(5):
			BulletData.summon_bullet(global_position, (2*PI*j/5)+(i*0.1), BulletData.BULLET_TYPES.BAM_MEDIUM)
		AudioManager.play("bullet/shoot_hard", 1)
		await get_tree().create_timer(0.1).timeout
	attack_delay = MAX_ATTACK_DELAY
	heart_delay = MAX_HEART_DELAY
