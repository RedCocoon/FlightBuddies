extends RichTextLabel

var time: float = 306

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameData.game_finished:
		return
	time -= delta
	text = str(min(300, ceil(time)))
	
