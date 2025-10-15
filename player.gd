extends CharacterBody2D


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

func _physics_process(delta: float) -> void:
	# Add the gravity.
	acceleration = Vector2.ZERO;
	if not is_on_floor():
		acceleration += get_gravity() * delta
		if velocity.y > 0 : velocity.y *= gravityFactor
		if velocity.y < 0 : acceleration.y *= 1.9
		jump_timer += delta
	else:
		jump_timer = 0;
		is_jumping = false
	
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
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
	
	move_and_slide()

func _process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0 : 
		$Sprite2D.texture = load("res://Sprites/masker_left.png")
		$Sprite2D.offset.x = 70;
		$CollisionShape2D.scale.x = -1
	if direction < 0 : 
		$Sprite2D.texture = load("res://Sprites/masker_right.png")
		$Sprite2D.offset.x = -70;
		$CollisionShape2D.scale.x = -1

func _input(event):
	if event.is_action_released("jump") and is_jumping:
		jump_timer = jump_time_max
