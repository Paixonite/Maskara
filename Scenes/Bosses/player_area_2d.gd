extends Area2D

var lastAreaEntereded = null

func _process(delta: float) -> void:
	if lastAreaEntereded != null :
		if lastAreaEntereded is Door:
			if Input.is_key_pressed(KEY_W) :
				#print("porta")
				get_tree().change_scene_to_file(lastAreaEntereded.scene)
				
		if lastAreaEntereded is Damage :
			get_parent().healthManager.damage(1)

func _on_area_entered(area: Area2D) -> void:
	lastAreaEntereded = area
	if area is Teleporter and not area.onCooldown and not area.link.onCooldown:
		get_parent().position = area.link.global_position
		area.onCooldown = true
		area.link.onCooldown = true


func _on_area_exited(area: Area2D) -> void:
	if lastAreaEntereded != null :
		lastAreaEntereded = null
