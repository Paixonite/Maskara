extends Area2D

var speed: float = 600.0
var direction: Vector2 = Vector2.RIGHT
var damage: int = 1

func _physics_process(delta):
	position += direction * speed * delta

func start(pos: Vector2, dir: Vector2, dmg: int):
	
	global_position = pos
	direction = dir
	damage = dmg
	rotation = dir.angle()
	

func _on_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(damage)
		queue_free()
	elif area.name == "Ground": 
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
