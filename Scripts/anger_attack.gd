extends Area2D

var vel:Vector2
var acc:Vector2
var originalPosition:Vector2
var originalScale:Vector2

func _ready() -> void:
	originalPosition = position
	originalScale = scale

func attack(target:Node2D) :
	var tween = create_tween()
	var parent = get_parent()
	parent.attacking = true
	tween.tween_property(self, "scale", scale*1.5, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", originalScale, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target.position, 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", originalPosition, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func():
		parent.attacking = false
	)
	
