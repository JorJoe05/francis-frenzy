extends State

var duration

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	duration = move_toward(duration, 0, _delta)
	
	if duration == 0:
		state_machine.transition_to("Normal")
	
	owner.move_and_slide()

func enter(_msg := {}) -> void:
	owner.position = _msg.launch_position
	owner.velocity = _msg.launch_velocity
	duration = _msg.launch_duration

func exit() -> void:
	pass
