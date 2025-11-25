class_name Teleporter extends Area2D

var link:Node2D
var onCooldown
var cooldown = 2


func _process(delta: float) -> void:
	if onCooldown :
		get_tree().create_timer(cooldown).timeout.connect(func():
			onCooldown = false
			)
