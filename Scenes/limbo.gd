extends Node2D

@export var player:PackedScene
@export var camera:PackedScene

func _ready() -> void:
	var p = player.instantiate()
	p.position = Vector2(400, -400)
	add_child(p)
	
	var c = camera.instantiate()
	add_child(c)
	c.target = p
	c.get_child(0).health = p.healthManager
	
	$AudioStreamPlayer.play()
	get_tree().create_timer(3).timeout.connect(func():
		$Control.visible = false
	)
