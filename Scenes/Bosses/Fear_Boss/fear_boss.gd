extends Boss

@export var target:Node2D
@export var jump_height:float = -300
@export var speed:float = 400
@export var totalHealth:int = 10
var vel:Vector2
var attacking = false

var timer: float = 0.0
var aux: int = 0

func _ready() -> void:
	health = totalHealth
	
func _physics_process(delta: float) -> void:
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
			$Hat.attack(target)
		
		#velocity.x+=(position.x-target.position.x)/250.0
