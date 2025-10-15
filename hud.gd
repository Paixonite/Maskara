extends Control

@export var health:Node2D

const Health = preload("res://health.tscn")

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
		var h = Health.instantiate()
		if(i <    health.currentHealth):
			h.texture = load("res://icon.svg")
			pass
		else:
			h.texture = load("res://Sprites/masker_left.png")
			pass
			
		h.position.x = i*-150
		add_child(h)
