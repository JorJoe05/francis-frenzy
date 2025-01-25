extends Entity

var prog: float = 0.0

func _physics_process(delta: float) -> void:
	prog += delta * 200.0
	velocity.y = -sin(prog + PI/2) * 60.0 * 2.0
	velocity.x = sin(prog) * 60.0 * 2.0 * 200.0
	
	move_and_slide()
