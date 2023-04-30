extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			show()


