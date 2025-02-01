extends Node2D

var prog: float = 0.0:
	set(value):
		prog = wrapf(value, 0.0, PI*2)

func _process(delta: float) -> void:
	prog += delta
	var fade = (sin(prog) * 0.25) - 0.25
	modulate = Color(1.0 + fade, 1.0 + fade, 1.0 + fade, 1.0)
