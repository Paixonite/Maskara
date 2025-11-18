extends Area2D

var velocity:Vector2

func _process(delta: float) -> void:
	position += velocity		
