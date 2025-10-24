extends CharacterBody2D

@export var animations:AnimationPlayer
@export var healthManager:Node2D

@export var SPEED = 500.0
@export var JUMP_VELOCITY_STEP = 30

@export var frictionFactor = 0.9;
@export var gravityFactor = 0.9;

var acceleration;

var jump_power_initial = -800
var jump_power = 0
var jump_time_max = 5
var jump_timer = 0
var is_jumping = false


# variáveis para altera o ataque
enum AttackType { FISICO, PROJETIL }
var current_attack: AttackType = AttackType.FISICO
var can_attack: bool = true


func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO;
	if not is_on_floor():
		acceleration += get_gravity() * delta
		if velocity.y > 0 : velocity.y *= gravityFactor
		if velocity.y < 0 : acceleration.y *= 1.9
		jump_timer += delta
	else:
		jump_timer = 0;
		is_jumping = false
	
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_timer = 0
		is_jumping = true
		acceleration.y = jump_power_initial
		jump_power = jump_power_initial
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		acceleration.x = direction * SPEED
	else:
		acceleration.x = move_toward(velocity.x, 0, SPEED)
	
	velocity += acceleration;
	velocity.x *= frictionFactor;
	
	velocity.x = clampf(velocity.x, -SPEED, SPEED);
	
	if direction != 0 : animations.play("walk")
	else : animations.stop()
	
	if direction != 0:
		for part in [$Head, $Body, $Eye]:
			part.flip_h = direction > 0
		
	move_and_slide()
	
	# ataque
	if Input.is_action_just_pressed("attack") and can_attack:
		match current_attack:
			AttackType.FISICO:
				_do_attack_fisico()
			AttackType.PROJETIL:
				_do_attack_projetil()
				


# troca o ataque
func _unhandled_input(event):
	
	if event.is_action_pressed("switch_attack"):
		if current_attack == AttackType.FISICO:
			current_attack = AttackType.PROJETIL
			print("Ataque trocado para: PROJETIL")
			
		else:
			current_attack = AttackType.FISICO
			print("Ataque trocado para: FÍSICO")


func _input(event):
	if event.is_action_released("jump") and is_jumping:
		jump_timer = jump_time_max


func _do_attack_fisico():
	print("EXECUTANDO ATAQUE FÍSICO!")
	#
	# AQUI VAI A LÓGICA DO ATAQUE FÍSICO
	#
	# Ex: Tocar animação de soco, ativar a Area2D do jogador
	#
	
	# Exemplo de como criar um "cooldown" para não atacar toda hora
	can_attack = false
	get_tree().create_timer(0.5).timeout.connect(func(): can_attack = true)

func recoil(origin:Vector2):
	pass
	

func _do_attack_projetil():
	print("EXECUTANDO ATAQUE PROJÉTIL!")
	#
	# AQUI VAI A LÓGICA DO ATAQUE PROJÉTIL
	#
	# Ex: Tocar animação de disparo, instanciar a cena do projétil
	#
	
	# Exemplo de como criar um "cooldown" para não atacar toda hora
	can_attack = false
	get_tree().create_timer(0.8).timeout.connect(func(): can_attack = true)


func _on_right_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	healthManager.damage(1)


func _on_left_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	healthManager.damage(1)
