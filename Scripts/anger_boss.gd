extends Area2D

@export var target: Node2D
@export var frictionFactor: float = 0.9
@export var speed: float = 100.0
@export var speedLimit: float = 300.0

var vel: Vector2 = Vector2.ZERO
var acc: Vector2 = Vector2.ZERO

var timer: float = 0.0
var aux: int = 0

var attacking: bool = false
var rng := RandomNumberGenerator.new()


func _process(delta: float) -> void:
	if target == null:
		return

	if not attacking:
		acc = (target.global_position - global_position).normalized() * speed
		vel.x += acc.x * frictionFactor * delta
		vel.x = clampf(vel.x, -speedLimit, speedLimit)
		position += vel * delta

	timer += delta
	if floor(timer) - aux == 1.0:
		aux = floor(timer)
		if int(fmod(timer, 2.0)) == 0:
			if rng.randi_range(0, 1) == 0:
				if has_node("Left"):
					start_attack($Left, target)
			else:
				if has_node("Right"):
					start_attack($Right, target)


func start_attack(arm: Node2D, target: Node2D) -> void:
	if attacking:
		return
	attacking = true
	vel = Vector2.ZERO
	acc = Vector2.ZERO
	arm.attack(target)
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.finished.connect(func(): attacking = false)
