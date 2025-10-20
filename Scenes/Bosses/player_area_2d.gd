extends Area2D


func _on_left_area_entered(area: Area2D) -> void:
	get_parent().healthManager.damage(1)


func _on_right_area_entered(area: Area2D) -> void:
	get_parent().healthManager.damage(1)
