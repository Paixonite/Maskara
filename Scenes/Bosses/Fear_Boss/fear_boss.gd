extends Boss

@export var target:Node2D
@export var jump_height:float = -300
@export var speed:float = 400
@export var totalHealth:float = 50
var rng := RandomNumberGenerator.new()
var vel:Vector2
var attacking = false

var timer: float = 0.0
var aux: int = 0

const DISPERSE = 0
const RAIN = 1

var difficultFactor = 1

func _ready() -> void:
	health = totalHealth
	
func _physics_process(delta: float) -> void:
	if health <= totalHealth/2 and difficultFactor == 1:
		$Body/Sprite2D.texture = load("res://Sprites/fear_boss_second_phase.png")
		$Hat/Sprite2D.texture = load("res://Sprites/fear_boss_hat_second_phase.png")
		difficultFactor += 2
		
	if not attacking:
		var acc = target.position-position 
		acc = acc.normalized()
		vel.x += acc.x
		vel *= 0.8
		position.x +=vel.x
		rotate(deg_to_rad(acc.x/5.0))
		rotation_degrees = clampf(rotation_degrees, deg_to_rad(-180), deg_to_rad(180))
		
	timer += delta
	if floor(timer) - aux == 1.0:
		aux = floor(timer)
		if int(fmod(timer, 1.0)) == 0:
			attack()
		
func attack() :
	if attacking :
		return
		
	var attack = rng.randi_range(0, 1)
	attacking = true

	if attack == DISPERSE :
		$Hat.disperse(target, difficultFactor)
	elif attack == RAIN :
		$Hat.rain(target, difficultFactor)
