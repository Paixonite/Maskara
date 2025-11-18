extends Control

@export var health:Node2D

@export var health_scene:PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#update_hud()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_hud()
		

func update_hud() :
	for i in get_children():
		i.queue_free()
		
	for i in range(health.maxHealth):
		var h = health_scene.instantiate()
		add_child(h)
		if(i < health.currentHealth):
			h.texture = load("res://Sprites/heart.png")
			pass
		else:
			h.texture = load("res://Sprites/heart_empty.png")
			pass
		h.scale *= 5
		h.position.x = 30 - i*150
		h.position.y = 300
