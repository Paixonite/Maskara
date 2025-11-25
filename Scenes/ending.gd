extends Node2D

@export var player:PackedScene
@export var camera:PackedScene

var timer = 0

func _ready() -> void:
	var p = player.instantiate()
	p.get_node("Pivot").get_node("Falling").visible = true
	
	p.position = Vector2(600, 300)
	p.unmasked = true
	add_child(p)
	p.setSpriteTint(3, 3, 3)
	
	var c = camera.instantiate()
	add_child(c)
	c.target = p
	c.get_child(0).health = p.healthManager
	c.get_node("HUD").visible = false
	$AudioStreamPlayer.play()

func _process(delta: float) -> void:
	timer += delta
	if floor(timer) == 4 :
		$Control/Control3.visible = true
	if floor(timer) == 8 :
		$Control/Control3.visible = false
		$Control/Label2.visible = true
	if floor(timer) == 12 :
		$Control/Label2.visible = false
		$Control/Label3.visible = true
	if floor(timer) == 16 :
		$Control/Label3.visible = false
		$Control/Label4.visible = true
	if floor(timer) == 20 :
		var tween = create_tween()
		tween.tween_property($AudioStreamPlayer, "volume_db", -60, 6)
		$Control/Label4.visible = false
		MaskHolder.currentMask = -1
		get_node("Player").unmasked = false
		
