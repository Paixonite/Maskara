extends Node2D

@export var player:PackedScene

func _ready() -> void:
	var p = player.instantiate()
	add_child(p)
