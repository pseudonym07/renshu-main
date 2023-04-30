extends Node

var currentHP = 100
var maxHP = 100
var damage = randi_range(20, 35)
var currentSP = 100
var maxSP = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
