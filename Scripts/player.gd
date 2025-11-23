extends CharacterBody2D

@export var animations:AnimationPlayer
@export var animationAttack:AnimationPlayer
@export var healthManager:Node2D

@export var SPEED = 500.0
@export var JUMP_VELOCITY_STEP = 30

@export var frictionFactor = 0.9
@export var gravityFactor = 0.9

enum Masks { HAPPY, SAD, ANGRY, SURPRISE, FEAR, LOVE }
@export var mask : Masks

var acceleration
var jump_power_initial = -600
var jump_power = 0
var jump_time_max = 5
var jump_timer = 0
var is_jumping = false

var is_walking

enum AttackType { FISICO, PROJETIL }
var current_attack: AttackType = AttackType.FISICO
var can_attack: bool = true
var physical_attack_cooldown = 0.5
var projectile_attack_cooldown = 0.8
var damage = 1

var attackType


func _process(delta: float) -> void:
	if mask == Masks.HAPPY :
		$Pivot/Mask.texture = load("res://Sprites/Masks/happy.png")
		SPEED = 750
		attackType = AttackType.FISICO
		physical_attack_cooldown = 0.2
	if mask == Masks.SAD :
		$Pivot/Mask.texture = load("res://Sprites/Masks/sad.png")
		SPEED = 500
		attackType = AttackType.PROJETIL
	if mask == Masks.ANGRY :
		$Pivot/Mask.texture = load("res://Sprites/Masks/angry.png")
		SPEED = 500
		attackType = AttackType.FISICO
		physical_attack_cooldown = 0.8
	if mask == Masks.SURPRISE :
		$Pivot/Mask.texture = load("res://Sprites/Masks/fear.png")
		SPEED = 500
		attackType = AttackType.FISICO
	if mask == Masks.FEAR :
		$Pivot/Mask.texture = load("res://Sprites/Masks/surprise.png")
		SPEED = 500
		attackType = AttackType.PROJETIL
	if mask == Masks.LOVE :
		$Pivot/Mask.texture = load("res://Sprites/Masks/love.png")
		SPEED = 500
		attackType = AttackType.PROJETIL
		
func _physics_process(delta: float) -> void:
	_process_jump(delta)
	_process_movement(delta)
	_process_visuals()
	_process_flip()
	_process_attack_hitbox()

	move_and_slide()
	#print($Pivot/AttackHitbox/Attack.visible)
	
	if Input.is_key_pressed(KEY_W) :
		$Pivot/AttackHitbox.rotation = deg_to_rad(-90)
	else :
		$Pivot/AttackHitbox.rotation = deg_to_rad(0)
		
	if Input.is_action_just_pressed("attack") and can_attack:
		match attackType:
			AttackType.FISICO: _do_attack_fisico()
			AttackType.PROJETIL: _do_attack_projetil()

func _process_jump(delta):
	acceleration = Vector2.ZERO

	if not is_on_floor():
		acceleration += get_gravity() * delta
		if velocity.y > 0: velocity.y *= gravityFactor
		if velocity.y < 0: acceleration.y *= 1.9
		jump_timer += delta
	else:
		jump_timer = 0
		is_jumping = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_timer = 0
		is_jumping = true
		acceleration.y = jump_power_initial
		jump_power = jump_power_initial

func _process_movement(delta):
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		acceleration.x = direction * SPEED
	else:
		acceleration.x = move_toward(velocity.x, 0, SPEED)

	velocity += acceleration
	velocity.x *= frictionFactor
	velocity.x = clampf(velocity.x, -SPEED, SPEED)

func _process_visuals():
	var direction = Input.get_axis("ui_left", "ui_right")

	var walking = direction != 0
	is_walking = walking
	$Pivot/Walk.visible = walking
	$Pivot/Idle.visible = not walking

	animations.play("walk" if walking else "idle")

func _process_flip():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0: $Pivot.scale.x = -1
	elif direction < 0: $Pivot.scale.x = 1

func _process_attack_hitbox():
	$Pivot/AttackHitbox/Attack.visible = animationAttack.is_playing()
	
func _input(event):
	if event.is_action_released("jump") and is_jumping:
		jump_timer = jump_time_max

func _do_attack_fisico():
	animationAttack.play("attack")
	_start_cooldown(physical_attack_cooldown)

func recoil(origin:Vector2, strength:float):
	print("toma")
	var dir = (global_position - origin).normalized()
	velocity += dir * strength
	velocity.y -= strength


func _do_attack_projetil():
	_start_cooldown(projectile_attack_cooldown)

func _start_cooldown(t):
	can_attack = false
	get_tree().create_timer(t).timeout.connect(func(): can_attack = true)
