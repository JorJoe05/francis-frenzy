extends Entity

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.x = 0.0

func _on_line_cross_trigger_triggered() -> void:
	var react = func():
		Game.player.global_position.y = global_position.y - 8
		Game.player.velocity.y = -512 - 64
	react.call_deferred()
