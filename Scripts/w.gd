extends Sprite2D
var a = 0

func _process(delta: float) -> void:
	position.y += cos(a)/10.0
	a += 0.1
