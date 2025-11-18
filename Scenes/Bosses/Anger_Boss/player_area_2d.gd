extends Area2D


func _on_left_area_entered(area: Area2D) -> void:
	get_parent().healthManager.damage(1)
	get_parent().recoil(area.position)


func _on_right_area_entered(area: Area2D) -> void:
	get_parent().healthManager.damage(1)
	get_parent().recoil(area.position)
