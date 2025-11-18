extends Area2D

var originalPosition
@export var pit_balls:PackedScene

func _ready() -> void:
	originalPosition = position

func attack(target:Node2D) :
	var p = pit_balls.instantiate()
	p.position = position
	p.velocity = target.position-position
	

	
