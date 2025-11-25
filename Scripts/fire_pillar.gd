extends Damage
var timer = 0;

func _ready() -> void:
	var tween = create_tween()
	$AudioStreamPlayer.play()
	tween.tween_interval(3.0)
	tween.finished.connect(func(): 
		$CPUParticles2D.emitting = false
		if get_parent().get_node("Anger_Boss") : get_parent().get_node("Anger_Boss").attacking = false
		)

func _process(delta: float) -> void:
	$CPUParticles2D.lifetime = lerpf($CPUParticles2D.lifetime, 0, 0.01)
	if not $CPUParticles2D.emitting :
			$AudioStreamPlayer.volume_db = lerpf($AudioStreamPlayer.volume_db, -1000, 0.01)
			get_tree().create_timer(0.5).timeout.connect(func():
				$AudioStreamPlayer.stop()
				queue_free()
			)
