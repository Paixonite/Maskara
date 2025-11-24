extends Area2D

var lastAreaEntereded = null

func _process(delta: float) -> void:
	if lastAreaEntereded != null :
		if lastAreaEntereded is Damage :
			get_parent().healthManager.damage(1)
			lastAreaEntereded = null

func _on_area_entered(area: Area2D) -> void:
	lastAreaEntereded = area
