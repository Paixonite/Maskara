class_name Damageable extends Area2D

var damageableActive = true

func _process(delta: float) -> void:
	var material = $Sprite2D.material
	material.set_shader_parameter("flashState", lerpf(material.get_shader_parameter("flashState"), 0, 0.1))

func take_damage(damage:float) :
	get_parent().take_damage(damage)
	var material = $Sprite2D.material
	material.set_shader_parameter("flashState", lerpf(material.get_shader_parameter("flashState"), 1, 1))
