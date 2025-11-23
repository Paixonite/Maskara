extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is Damage:
		get_parent().healthManager.damage(1)
		get_parent().recoil(area.position, 800)
