extends Area2D

var lastAreaEntered = null

func _process(delta: float) -> void:
	var player = get_parent().get_parent()
	if $Attack.visible and lastAreaEntered != null:
		lastAreaEntered.take_damage(player.damage)
		player.recoil(lastAreaEntered.global_position, 500)
		lastAreaEntered = null
		
func _on_area_entered(area: Area2D) -> void:
		if area is Damageable :
			lastAreaEntered = area
