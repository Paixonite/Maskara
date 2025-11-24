extends Damage

func _ready() -> void:
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.finished.connect(func(): 
		queue_free()
		get_parent().get_node("Anger_Boss").attacking = false
		)
