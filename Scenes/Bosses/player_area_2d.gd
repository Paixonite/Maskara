extends Area2D

var lastAreaEntereded = null

func _process(delta: float) -> void:
	if lastAreaEntereded != null :
		if lastAreaEntereded is Door:
			lastAreaEntereded.get_node("W").visible = true
			if Input.is_key_pressed(KEY_W) :
				#print("porta")
				get_tree().change_scene_to_file(lastAreaEntereded.scene)
				
		if lastAreaEntereded is Damage and lastAreaEntereded.damageActive and !get_parent().healthManager.cooldown:
			$AudioStreamPlayer.play()
			get_parent().healthManager.damage(1)
		
		if lastAreaEntereded is Mask :
			MaskHolder.addMask(lastAreaEntereded.mask_value)
			get_tree().change_scene_to_file("res://Scenes/limbo.tscn")

func _on_area_entered(area: Area2D) -> void:
	lastAreaEntereded = area
	if area is Teleporter and not area.onCooldown and not area.link.onCooldown:
		get_parent().position = area.link.global_position
		area.onCooldown = true
		area.link.onCooldown = true
	if area.name == "Limbo" :
		get_tree().change_scene_to_file("res://Scenes/limbo.tscn")
	if area.name == "Final" :
		get_tree().change_scene_to_file("res://Scenes/limbo.tscn")


func _on_area_exited(area: Area2D) -> void:
	if lastAreaEntereded != null :
		if lastAreaEntereded is Door :
			lastAreaEntereded.get_node("W").visible = false
		lastAreaEntereded = null
	
