extends Mask
var a = 0

func _ready() -> void:
	mask_value = MaskHolder.Masks.ANGRY
	
func _process(delta: float) -> void:
	position.y += cos(a)
	a += 0.1
