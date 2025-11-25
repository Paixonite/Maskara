extends Damage

var vel:Vector2
var acc:Vector2
var originalPosition:Vector2
var originalScale:Vector2

func _ready() -> void:
	originalPosition = position
	originalScale = scale
	damageActive = false
	
func _process(delta: float) -> void:
	var parent = get_parent()
	var target = parent.target

	var v = target.global_position - self.global_position
	var angle = v.angle()
	if self == get_parent().get_child(2) :
		angle += deg_to_rad(180)
	var r = self.global_rotation
	self.global_rotation = lerp_angle(r,angle,0.02)

func attack(target:Node2D) :
	var tween = create_tween()
	var parent = get_parent()
	damageActive = true
	tween.tween_property(self, "scale", scale*1.3, 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", originalScale, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", Vector2(target.position.x, 560), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	get_tree().create_timer(0.7).timeout.connect(func():
		damageActive = false
		get_parent().get_node("AudioStreamPlayer").stream = load("res://Sounds/explosion-312361.mp3")
		get_parent().get_node("AudioStreamPlayer").play()
		#if get_parent().camera_to_shake : get_parent().camera_to_shake.start_shake();
	)
	tween.tween_property(self, "position", originalPosition, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func():
		parent.attacking = false
	)
	
