extends Node2D

var a = 0

func _process(delta: float) -> void:
	position.y = cos(a)*5
	a+=0.1
