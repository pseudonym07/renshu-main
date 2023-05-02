extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_text("250/250")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


