extends CharacterBody2D

@export var animations:AnimationPlayer
@export var animationAttack:AnimationPlayer
@export var healthManager:Node2D
@export var projectile_scene: PackedScene
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
var is_jumping = true

var is_walking

enum AttackType { FISICO, PROJETIL }
var current_attack: AttackType = AttackType.FISICO
var can_attack: bool = true
var physical_attack_cooldown = 0.5
var projectile_attack_cooldown = 0.2
var damage = 1

var attackType

var unmasked = false

func _process(delta: float) -> void:
	setSpriteTint(1, 1, 1, 1)
	if not unmasked :
		$Pivot/Mask.visible = true
		if mask == Masks.HAPPY :
			$Pivot/Mask.texture = load("res://Sprites/Masks/happy.png")
			setSpriteTint(1, 0.7, 0, 0)
			SPEED = 750
			attackType = AttackType.FISICO
			physical_attack_cooldown = 0.2
			damage = 1
		if mask == Masks.SAD :
			$Pivot/Mask.texture = load("res://Sprites/Masks/sadness.png")
			setSpriteTint(0, 0.3, 1, 0)
			SPEED = 300
			attackType = AttackType.PROJETIL
			projectile_attack_cooldown = 0.4
			damage = 2
		if mask == Masks.ANGRY :
			$Pivot/Mask.texture = load("res://Sprites/Masks/angry.png")
			setSpriteTint(1, 0, 0, 0)
			SPEED = 600
			attackType = AttackType.FISICO
			physical_attack_cooldown = 0.4
			damage = 2
		if mask == Masks.SURPRISE :
			$Pivot/Mask.texture = load("res://Sprites/Masks/surprise.png")
			setSpriteTint(0, 0.5, 0.8, 0)
			SPEED = 650
			attackType = AttackType.FISICO
			physical_attack_cooldown = 0.3
			damage = 1
		if mask == Masks.FEAR :
			$Pivot/Mask.texture = load("res://Sprites/Masks/fear.png")
			setSpriteTint(1, 0, 1, 0)
			SPEED = 300
			attackType = AttackType.PROJETIL
			projectile_attack_cooldown = 0.3
			damage = 1
		if mask == Masks.LOVE :
			$Pivot/Mask.texture = load("res://Sprites/Masks/love.png")
			setSpriteTint(1, 0, 0.5, 0)
			SPEED = 400
			attackType = AttackType.PROJETIL
			projectile_attack_cooldown = 0.6
			damage = 3
		
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
		
	if healthManager.currentHealth == 0 :
		get_tree().change_scene_to_file("res://Scenes/limbo.tscn")

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
	if not is_jumping :
		$Pivot/Walk.visible = walking
		$Pivot/Idle.visible = not walking
		$Pivot/Jumping.visible = false
		$Pivot/Falling.visible = false
	else :
		$Pivot/Walk.visible = false
		$Pivot/Idle.visible = false
		if velocity.y < 0 :
			$Pivot/Jumping.visible = true
			$Pivot/Falling.visible = false
		else :
			$Pivot/Jumping.visible = false
			$Pivot/Falling.visible = true
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
	var dir = (global_position - origin).normalized()
	velocity += dir * strength


func _do_attack_projetil():
	var p = projectile_scene.instantiate()
	get_parent().add_child(p)
	var spawn_pos = global_position
	if has_node("Pivot/SpawnPoint"):
		spawn_pos = $Pivot/SpawnPoint.global_position
	
	var dir = Vector2.RIGHT
	if Input.is_key_pressed(KEY_W):
		dir = Vector2.UP
		spawn_pos.x = global_position.x 
		spawn_pos.y -= 40 
	else:
		if $Pivot.scale.x == -1:
			dir = Vector2.RIGHT
		else:
			dir = Vector2.LEFT
	
	p.start(spawn_pos, dir, damage)
		
	_start_cooldown(projectile_attack_cooldown)


func _start_cooldown(t):
	can_attack = false
	get_tree().create_timer(t).timeout.connect(func(): can_attack = true)

func setSpriteTint(r, g, b, a) :
	$Pivot/Idle.material.set_shader_parameter("tint_color", Vector4(r, g, b, a))
	$Pivot/Walk.material.set_shader_parameter("tint_color", Vector4(r, g, b, a))
	$Pivot/Jumping.material.set_shader_parameter("tint_color", Vector4(r, g, b, a))
	$Pivot/Falling.material.set_shader_parameter("tint_color", Vector4(r, g, b, a))

func setSpriteTintVector(c:Vector4) :
	$Pivot/Idle.material.set_shader_parameter("tint_color", Vector4(c.x, c.y, c.z, c.w))
	$Pivot/Walk.material.set_shader_parameter("tint_color", Vector4(c.x, c.y, c.z, c.w))
	$Pivot/Jumping.material.set_shader_parameter("tint_color", Vector4(c.x, c.y, c.z, c.w))
	$Pivot/Falling.material.set_shader_parameter("tint_color", Vector4(c.x, c.y, c.z, c.w))
