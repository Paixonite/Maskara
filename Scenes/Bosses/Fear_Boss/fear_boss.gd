extends Boss

@export var target:Node2D
@export var jump_height:float = -300
@export var speed:float = 400
@export var camera_to_shake: Camera2D
@export var totalHealth:float = 50
var rng := RandomNumberGenerator.new()
var vel:Vector2
var attacking = false

var timer: float = 0.0
var aux: int = 0

const DISPERSE = 0
const RAIN = 1
const CRASH = 2
var acc = Vector2(0, 0)
var difficultFactor = 1

func _ready() -> void:
	health = totalHealth
	
func _physics_process(delta: float) -> void:
	if health <= totalHealth/2 and difficultFactor == 1:
		$Body/Sprite2D.texture = load("res://Sprites/fear_boss_second_phase.png")
		$Hat/Sprite2D.texture = load("res://Sprites/fear_boss_hat_second_phase.png")
		$Roar.play()
		difficultFactor = 2
		camera_to_shake.start_shake()
		attacking = false
		
	#if not attacking:
	acc.x += target.position.x-position.x 
	acc = acc.normalized()
	vel += acc
	vel *= 0.9
	position += vel*difficultFactor
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
		
	var attack
	if difficultFactor == 1 :
		attack = rng.randi_range(0, 1)
	if difficultFactor == 2 :
		attack = rng.randi_range(0, 2)
	attacking = true

	if attack == DISPERSE :
		$Hat.disperse(target, difficultFactor)
	elif attack == RAIN :
		$Hat.rain(target, difficultFactor)
	elif attack == CRASH :
		crash()
	
func crash():
	attacking = false
	var tween = create_tween()
