extends BaseEnemy

var vine_spawned = false
var vine
var vine_rose_delay = 3

func _ready():
	super()
	AudioManager.play_bgm("vs_ogu")

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		spawn_vine()
	if vine and health <= MAX_HEALTH / 4.0:
		if vine_rose_delay > 0:
			vine_rose_delay -= delta
		else:
			vine_rose_delay = 3
			vine.add_rose()
	
func hit(amount):
	super(amount)
	if randf() > 0.9:
		BulletData.summon_unique_bullet(global_position, randf_range(-PI, PI), BulletData.BULLET_TYPES.OGU_ROSE)
	if health <= MAX_HEALTH / 2.0 and not vine_spawned:
		spawn_vine()

func spawn_vine():
	vine_spawned = true
	var pos = Vector2(0, -192)
	var scene = load("res://src/actors/enemies/ogu/vine.tscn").instantiate()
	var bh = get_tree().get_first_node_in_group("BulletHolder")
	bh.add_child(scene)
	vine = scene
	scene.global_position = pos
	

func die():
	dead = true
	GameData.show_win_screen("Ogu")


func _on_rose_timer_timeout():
	if len(get_tree().get_nodes_in_group("Rose")) < 3:
		var player = get_tree().get_first_node_in_group("Player")
		var bullet_holder = get_tree().get_first_node_in_group("BulletHolder")
		var rose_scene = load("res://src/actors/enemies/ogu/rose_preempt.tscn")
		var child = rose_scene.instantiate()
		bullet_holder.add_child(child)
		child.global_position = player.global_position
