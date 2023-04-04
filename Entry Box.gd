extends TextEdit
var input = ""

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (input != get_text()):
		input = get_text()
		print(input)
		AskPname.playerName = input
		
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			get_tree().change_scene_to_file("res://BattleUI.tscn")
			print(input)
