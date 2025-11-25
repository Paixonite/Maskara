extends Boss

@export var target: Node2D
@export var camera_to_shake: Camera2D
@export var frictionFactor: float = 0.9
@export var speed: float = 100.0
@export var speedLimit: float = 400.0
@export var totalHealth: int = 100
@export var firePillars:PackedScene
@export var fire:PackedScene

const HAND = 0.7
const FIRE = 1

var vel: Vector2 = Vector2.ZERO
var acc: Vector2 = Vector2.ZERO

var timer: float = 0.0
var aux: int = 0

var attacking: bool = false
var rng := RandomNumberGenerator.new()

var lastHand
var yFactor = 0;



var difficultFactor = 1

func _ready() -> void:
	health = 2
	lastHand = rng.randi_range(0, 1)

func _process(delta: float) -> void:
	if health <= totalHealth/2 and difficultFactor == 1:
		camera_to_shake.start_shake()
		$DamageHitbox/Sprite2D.texture = load("res://Sprites/anger_boss_body_second_phase.png")
		$Roar.play()
		difficultFactor = 2
		
		
	if target == null:
		return
	acc = (target.global_position - global_position).normalized() * speed
	acc.x -= (global_position.x - get_parent().get_node("Right_Wall").position.x)
	acc.x -= (global_position.x - get_parent().get_node("Left_Wall").position.x)
	acc = acc.normalized() 
	vel.x += acc.x * frictionFactor * delta * speed
	vel.x = clampf(vel.x, -speedLimit, speedLimit)
	position += vel * delta
	rotate(deg_to_rad(acc.x/100.0))
	$DamageHitbox.position.y += cos(yFactor)/10.0
	rotation_degrees = clampf(rotation_degrees, deg_to_rad(-180), deg_to_rad(180))
	yFactor+=0.01
	
	if not attacking:
		timer += delta
		if floor(timer) - aux == 2/difficultFactor:
			var attack = rng.randf_range(0, 1)
			aux = floor(timer)
			if attack < HAND:
				if lastHand == 0 :
					lastHand = 1
				else :
					lastHand = 0
				if lastHand == 0:
					if has_node("Left"):
						start_attack($Left, target)
				else:
					if has_node("Right"):
						start_attack($Right, target)
			elif attack < FIRE :
				set_fire()
		
	
	if health <= 0 :
		if not $Roar.playing :
			$Roar.play()
		$Death.emitting = true
		camera_to_shake.start_shake()
		attacking = true
		$Left.damageActive = false
		$Right.damageActive = false
		$DamageHitbox.damageableActive = false
		get_tree().create_timer(6).timeout.connect(func():
			vel.y += 10
		)
		get_parent().get_node("Mask").visible = true
		
		get_tree().create_timer(8).timeout.connect(func():
			get_parent().get_node("Mask").get_node("Sprite2D").visible = true
			get_parent().get_node("Mask").get_node("CollisionShape2D").disabled = false
			queue_free()
		)
		get_tree().create_timer(7).timeout.connect(func():
			get_parent().get_node("Mask").get_node("CPUParticles2D").emitting = true
		)

func set_fire() :
	var nPillars = rng.randi_range(5, 8)*difficultFactor
	var pillars = []
	var fires = []
	
	attacking = true
	
	for i in range(0, nPillars) :
		pillars.append(firePillars.instantiate())
		fires.append(fire.instantiate())
		var randomX = rng.randf_range(-250, 1100)
		fires[i].position.x = randomX
		fires[i].position.y = 560
		get_parent().add_child(fires[i])
		
	get_tree().create_timer(2).timeout.connect(func():
		for i in range(0, nPillars) :
			pillars[i].position.x = fires[i].position.x
			pillars[i].position.y = 560
			get_parent().add_child(pillars[i])
		)
		
	get_tree().create_timer(3).timeout.connect(func():
		for i in range(0, nPillars) :
			fires[i].queue_free()
		)
	
func start_attack(arm: Node2D, target: Node2D) -> void:
	attacking = true
	
	vel = Vector2.ZERO
	acc = Vector2.ZERO
	arm.attack(target)
	get_tree().create_timer(1.225).timeout.connect(func():
		if camera_to_shake != null:
			camera_to_shake.start_shake()
	)
	
