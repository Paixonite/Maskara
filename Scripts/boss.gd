class_name Boss extends Area2D

var health:float

func take_damage(damage:float) :
	health -= damage
	print(health)
