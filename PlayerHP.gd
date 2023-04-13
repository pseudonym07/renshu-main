extends Label
var  monster_hp = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	set_text("100/100")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#get_text(str(monster_hp))

