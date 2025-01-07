extends State

var duration

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	duration = move_toward(duration, 0, _delta)
	
	if duration == 0:
		state_machine.transition_to("Normal")
	
	owner.move_and_slide()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	owner.position = _msg.launch_position
	owner.velocity = _msg.launch_velocity
	duration = _msg.launch_duration

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	var to_local = func(): owner.velocity = owner.vector_to_local(owner.velocity)
	to_local.call_deferred()
