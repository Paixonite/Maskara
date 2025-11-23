extends Damageable

var originalPosition
@export var pit_balls:PackedScene
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	originalPosition = position
	

func attack(target:Node2D) :
	var p = pit_balls.instantiate()
	get_parent().get_parent().add_child(p)
	p.position = global_position
	p.position.y -= 100
	p.vel.x = (target.position.x-global_position.x)/rng.randf_range(25, 50)
	p.vel.y -= 50
	

	
