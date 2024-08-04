extends BaseEnemy

var anim_cycle_angle: float = 0
var original_position: Vector2 = Vector2.ZERO


func _ready():
	super()
	original_position = global_position

func _process(delta):
	wander(delta)
	
func hit(amount):
	super(amount)
	
func die():
	dead = true
	GameData.show_win_screen("Biggie")


func _on_rose_timer_timeout():
	if len(get_tree().get_nodes_in_group("Rose")) < 12:
		var player = get_tree().get_first_node_in_group("Player")
		var bullet_holder = get_tree().get_first_node_in_group("BulletHolder")
		var rose_scene = load("res://src/actors/enemies/ogu/rose_preempt.tscn")
		var child1 = rose_scene.instantiate()
		var child2 = rose_scene.instantiate()
		var child3 = rose_scene.instantiate()
		bullet_holder.add_child(child1)
		bullet_holder.add_child(child2)
		bullet_holder.add_child(child3)
		child1.global_position = player.global_position + Vector2(0, -16)
		child2.global_position = player.global_position + Vector2(16, 16)
		child3.global_position = player.global_position + Vector2(-16, 16)
		child1.rose_life_modifier = 0.5
		child2.rose_life_modifier = 0.5
		child3.rose_life_modifier = 0.5

func wander(delta):
	anim_cycle_angle += delta
	if anim_cycle_angle > 2*PI:
		anim_cycle_angle = 0
	global_position.y = original_position.y + sin(anim_cycle_angle)
	global_position.x = original_position.x + cos(anim_cycle_angle)*20

func _on_shard_timer_timeout():
	for i in range(16):
		var bullet = BulletData.summon_bullet(global_position+(16*Vector2.LEFT.rotated(i*2*PI/8.0)), 0, BulletData.BULLET_TYPES.BAM_SHARD)
		bullet.delay = 0.2
		AudioManager.play("bullet/shoot_glass", -5)
		get_tree().create_timer(0.2).timeout.connect(thonk)
		await get_tree().create_timer(0.1).timeout

func thonk():
	AudioManager.play("bullet/glass_thonk")


func _on_laser_timer_timeout():
	var laser_preempt = load("res://src/actors/enemies/biggie/laser_preempt.tscn").instantiate()
	laser_preempt.new_parent = self
	add_child(laser_preempt)
	laser_preempt.global_position = global_position
