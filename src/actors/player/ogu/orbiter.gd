extends Node2D

var bonus_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bonus_time > 0:
		bonus_time -= delta
		rotation += delta * (2*PI)
	rotation += delta * (2*PI)

