class_name Damage extends Area2D

var vel:Vector2
var acc:Vector2
var timer: float = 0.0
var aux: int = 0

func _process(delta: float) -> void:
	acc = Vector2(0, 1)
	vel += acc
	vel.y *= 0.96
	position += vel	
	rotation += 0.1	
	
	timer += delta
	if floor(timer) - aux == 1.0:
		aux = floor(timer)
		if int(fmod(timer, 5.0)) == 0:
			queue_free()
