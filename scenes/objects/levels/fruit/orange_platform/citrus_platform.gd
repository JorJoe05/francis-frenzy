@tool
extends Entity

enum CitrusVariant {
	ORANGE,
	LEMON,
	LIME,
	GRAPEFRUIT
}

@onready var orange_texture = preload("res://sprites/levels/fruit/spr_orange_platform.png")
@onready var lemon_texture = preload("res://sprites/levels/fruit/spr_lemon_platform.png")
@onready var lime_texture = preload("res://sprites/levels/fruit/spr_lime_platform.png")
@onready var grapefruit_texture = preload("res://sprites/levels/fruit/spr_grapefruit_platform.png")

@export var variant: CitrusVariant = 0:
	set(value):
		variant = value
		$Platform.texture = [orange_texture, lemon_texture, lime_texture, grapefruit_texture][variant]
@export var length: int = 2:
	set(value):
		length = max(value, 2)
		$Platform.size.x = 32 * length
		$Platform.position.x = -$Platform.size.x / 2
		$CollisionShape2D.shape.size.x = 32 * length

func _ready() -> void:
	$Platform.texture = [orange_texture, lemon_texture, lime_texture, grapefruit_texture][variant]
