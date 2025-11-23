extends Node2D

@export var maxHealth = 5;
@export var currentHealth = maxHealth
@export var cooldownTime = 2.5
var cooldown = false

func _process(delta: float) -> void:
	var material_Walk = get_parent().get_child(0).get_child(1).material
	var material_Idle = get_parent().get_child(0).get_child(2).material

	material_Walk.set_shader_parameter("flashState", lerpf(material_Walk.get_shader_parameter("flashState"), 0, 0.3))	
	material_Idle.set_shader_parameter("flashState", lerpf(material_Idle.get_shader_parameter("flashState"), 0, 0.3))	

func damage(amount : int) :
	if !cooldown : 
		var material_Walk = get_parent().get_child(0).get_child(1).material
		var material_Idle = get_parent().get_child(0).get_child(2).material

		material_Walk.set_shader_parameter("flashState", lerpf(material_Walk.get_shader_parameter("flashState"), 1, 1))	
		material_Idle.set_shader_parameter("flashState", lerpf(material_Idle.get_shader_parameter("flashState"), 1, 1))	
		
		currentHealth -= amount
		cooldown = true
	await get_tree().create_timer(cooldownTime).timeout
	cooldown = false
	
func heal (amount : int) :
	currentHealth+=amount
