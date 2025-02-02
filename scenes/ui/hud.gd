extends Control

var colors = [
	Color(1.0, 0.039, 0.039),
	Color(1.0, 0.447, 0.0),
	Color(1.0, 0.937, 0.0),
	Color(0.137, 1.0, 0.0),
	Color(0.0, 0.537, 1.0),
	Color(0.4, 0.0, 1.0)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play(&"default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$TextureProgressBar.value = Game.player.health.health
	$ProgressBar.value = wrap(Game.player.yorbs, 0, 100)
	$ProgressBar.get("theme_override_styles/fill").bg_color = colors[$AnimatedSprite2D.frame]
	$Label.text = str(Game.player.yorbs) + "x"
