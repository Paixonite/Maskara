class_name Boss extends Area2D

var health:float

func _process(delta: float) -> void:
	if health == 0 :
		queue_free()

func take_damage(damage:float) :
	health -= damage
	print(health)
