extends Sprite2D

@export var SPEED = 10

var original_position : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += SPEED * delta
	if position.y - original_position.y > texture.get_height() / 2.0:
		position.y -= texture.get_height() / 2.0
	
