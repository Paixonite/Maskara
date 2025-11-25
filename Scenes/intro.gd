extends Node2D

@export var player:PackedScene
@export var camera:PackedScene

func _ready() -> void:
	var p = player.instantiate()
	p.position = Vector2(600, 300)
	p.gravityFactor = 0
	p.unmasked = true
	add_child(p)
	
	var c = camera.instantiate()
	add_child(c)
	c.target = p
	c.get_child(0).health = p.healthManager
	c.get_node("HUD").visible = false
	
