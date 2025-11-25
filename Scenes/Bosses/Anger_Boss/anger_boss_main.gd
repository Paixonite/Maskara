extends Node2D

@export var player:PackedScene
@export var camera:PackedScene

func _ready() -> void:
	var p = player.instantiate()
	p.position = $Anger_Boss.position
	add_child(p)
	
	var c = camera.instantiate()
	c.target = p
	add_child(c)
	c.get_child(0).health = p.healthManager
	$Anger_Boss.target = p
	$Anger_Boss.camera_to_shake = c
	$AudioStreamPlayer.play()
	
	
