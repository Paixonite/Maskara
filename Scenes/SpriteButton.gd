extends Button

@export var imagem1 = Texture2D;
@export var imagem2 = Texture2D;
@export var imagem3 = Texture2D;

func _ready() -> void:
	$Sprite2D.texture = imagem1;

func _on_button_down() -> void:
	$Sprite2D.texture = imagem3;

func _on_button_up() -> void:
	$Sprite2D.texture = imagem2;

func _on_mouse_entered() -> void:
	$Sprite2D.texture = imagem2;

func _on_mouse_exited() -> void:
	$Sprite2D.texture = imagem1;
