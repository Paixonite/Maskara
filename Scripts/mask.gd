extends Node2D

func _process(delta):
	var pivot = get_parent()
	var tween = create_tween()
	tween.tween_property(self, "global_position", pivot.global_position, 0.05).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
