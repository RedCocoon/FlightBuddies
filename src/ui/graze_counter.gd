extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.graze_changed.connect(set_graze)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_graze(val):
	text = "[center]Graze:\n%s" % ceili(val)
