extends RigidBody2D

@export var target:Node2D
@export var jump_height:float = -300
@export var speed:float = 400

var velocity:Vector2
var attacking = false

func _physics_process(delta: float) -> void:
	if not attacking:
		var acceleration = target.position-position 
		acceleration = acceleration.normalized()
		velocity.x += acceleration.x
		velocity *= 0.8
		position.x +=velocity.x

	if abs(target.position.x-position.x) < 400:
		var tween = create_tween()
		$Pivot/Head.attack(target)
		velocity.x+=(position.x-target.position.x)/250.0
	
	_process_flip()
			
func _process_flip():
	if position.x-target.position.x < 0 :
		$Pivot.scale.x = 1
	if position.x-target.position.x < 0 :
		$Pivot.scale.x = -1
