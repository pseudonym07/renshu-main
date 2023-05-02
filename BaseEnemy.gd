extends Resource


func _ready():
	pass


@export var name: String = "Enemy"
@export var texture: Texture = null
@export var health: int = 250
@export var damage: int
