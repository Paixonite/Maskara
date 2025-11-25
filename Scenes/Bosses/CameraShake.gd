extends Camera2D

@export var shake_strength: float = 15.0
@export var shake_duration: float = 0.3
@export var shake_decay_rate: float = 5.0 
@export var target:Node2D
@export var offsetY:float = 150
var _current_shake_strength: float = 0.0
var vel:Vector2

func _process(delta):

	position = target.position
	position.y -= offsetY
		#var tween = create_tween()
		#tween.tween_property(self, "position", target.position-Vector2(0, offsetY), 0.1)
	#position.y -= 250
	#position = target.position
	#position.y -= offsetY
	if _current_shake_strength > 0:
		_current_shake_strength = lerpf(_current_shake_strength, 0.0, shake_decay_rate * delta)
		
		
		var shake_offset = Vector2(
			randf_range(-1.0, 1.0) * _current_shake_strength,
			randf_range(-1.0, 1.0) * _current_shake_strength
		)
		offset = shake_offset
	else:
		_current_shake_strength = 0.0
		offset = Vector2.ZERO

# bosssssssss
func start_shake():
	_current_shake_strength = shake_strength
