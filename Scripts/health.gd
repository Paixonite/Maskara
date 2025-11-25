extends Node2D

@export var maxHealth = 5;
@export var currentHealth = maxHealth
@export var cooldownTime = 1.5
var cooldown = false
var a = 0
var aux = 0
var originalTint

func _process(delta: float) -> void:
	var player = get_parent()
	var material_Walk = get_parent().get_child(0).get_child(1).material
	var material_Idle = get_parent().get_child(0).get_child(2).material
	originalTint = material_Walk.get_shader_parameter("tint_color")
	
	if cooldown :
		player.setSpriteTintVector(originalTint)
		player.setSpriteTint(1, 1, 1, 1)
		aux = cos(a)
		material_Walk.set_shader_parameter("intensity", lerpf(material_Walk.get_shader_parameter("intensity"), aux, 0.1))	
		material_Idle.set_shader_parameter("intensity", lerpf(material_Idle.get_shader_parameter("intensity"), aux, 0.1))	
		a += 0.4
	else :
		a = 0
		player.setSpriteTintVector(originalTint)
		material_Walk.set_shader_parameter("intensity", lerpf(material_Walk.get_shader_parameter("intensity"), 0.15, 0.2))	
		material_Idle.set_shader_parameter("intensity", lerpf(material_Idle.get_shader_parameter("intensity"), 0.15, 0.2))	

func damage(amount : int) :
	var player = get_parent()
	var material_Walk = get_parent().get_child(0).get_child(1).material
	var material_Idle = get_parent().get_child(0).get_child(2).material
	
	if !cooldown : 
		player.setSpriteTint(1, 1, 1, 1)
	
		material_Walk.set_shader_parameter("intensity", lerpf(material_Walk.get_shader_parameter("intensity"), 1, 1))	
		material_Idle.set_shader_parameter("intensity", lerpf(material_Idle.get_shader_parameter("intensity"), 1, 1))	
		
		currentHealth -= amount
		cooldown = true
	await get_tree().create_timer(cooldownTime).timeout
	cooldown = false
	
	player.setSpriteTintVector(originalTint)
	material_Walk.set_shader_parameter("intensity", 0.15)	
	material_Idle.set_shader_parameter("intensity", 0.15)	
func heal (amount : int) :
	currentHealth+=amount
