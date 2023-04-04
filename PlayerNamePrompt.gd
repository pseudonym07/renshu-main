extends Label




# Called when the node enters the scene tree for the first time.
func _ready():
	set_text("The Sketch dragon appears! Defeat it, Hero " + AskPname.playerName + "!")
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			set_visible_ratio(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
