extends Damageable

var originalPosition
@export var pit_balls:PackedScene
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	originalPosition = position
	

func shoot(target:Node2D) :
	var tween = create_tween()
	tween.tween_property(self, "position", position+Vector2(0, 5), 0.2).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", position, 0.1).set_trans(Tween.TRANS_QUINT)
	tween.finished.connect(func():
		var p = pit_balls.instantiate()
		get_parent().get_parent().add_child(p)
		p.position = global_position
		p.position.y -= 100
		p.vel.x = (target.position.x-global_position.x)/rng.randf_range(25, 50)
		p.vel.y -= rng.randf_range(20, 50)
		get_parent().attacking = false
	)

func disperse(target:Node2D) :
	var tween = create_tween()
	tween.tween_property(self, "position", position+Vector2(0, 5), 0.9).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", position, 0.1).set_trans(Tween.TRANS_QUINT)
	tween.finished.connect(func():
		var nBalls = rng.randi_range(2, 5)
		for i in range(0, nBalls) :
			var p = pit_balls.instantiate()
			get_parent().get_parent().add_child(p)
			p.position = global_position
			p.position.y -= 100
			p.vel.x = ((target.position.x-global_position.x)/100.0)+rng.randf_range(-5, 5)
			p.vel.y -= rng.randf_range(20, 40)
		get_parent().attacking = false
	)
	
func rain(target:Node2D) :
	var tween = create_tween()
	tween.tween_property(self, "position", position+Vector2(0, 5), 0.9).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", position, 0.1).set_trans(Tween.TRANS_QUINT)
	tween.finished.connect(func():
		var nBalls = rng.randi_range(10, 25)
		for i in range(0, nBalls) :
			var p = pit_balls.instantiate()
			get_parent().get_parent().add_child(p)
			p.position = global_position
			p.position.y -= 100
			p.vel.x = (i-nBalls/2.0)*rng.randf_range(4, 7)
			p.vel.y -= rng.randf_range(20, 30)
		get_parent().attacking = false
	)

	
