extends Mask
var a = 0

func _ready() -> void:
	mask_value = MaskHolder.Masks.FEAR
	
func _process(delta: float) -> void:
	position.y += cos(a)
	a += 0.1
