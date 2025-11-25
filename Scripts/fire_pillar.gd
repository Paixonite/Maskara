extends Damage
var timer = 0;

func _ready() -> void:
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.finished.connect(func(): 
		$CPUParticles2D.emitting = false
		get_parent().get_node("Anger_Boss").attacking = false
		)

func _process(delta: float) -> void:
	$CPUParticles2D.lifetime = lerpf($CPUParticles2D.lifetime, 0, 0.01)
	if not $CPUParticles2D.emitting :
			get_tree().create_timer(0.5).timeout.connect(func():
				queue_free()
			)
