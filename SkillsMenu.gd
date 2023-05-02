extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	get_child(0).hide()
	get_child(1).hide()
	get_child(2).hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
