extends State

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	
	#region 
	
	owner.ground_on = owner.is_on_floor()
	
	var input_h = Input.get_axis("left", "right")
	
	match int(sign(input_h)):
		-1:
			if owner.velocity.x > 0:
				owner.decelerate(_delta, 1)
				if owner.ground_on:
					owner.skid = true
			else:
				if owner.velocity.x >= -owner.physics.speed_run:
					owner.accelerate(_delta, -1)
				else:
					owner.apply_friction(_delta)
				owner.face = -1
				owner.skid = false
		0:
			owner.apply_friction()
		1:
			if owner.velocity.x < 0:
				owner.decelerate(_delta, -1)
				if owner.ground_on:
					owner.skid = true
			else:
				if owner.velocity.x <= owner.physics.speed_run:
					owner.accelerate(_delta, 1)
				else:
					owner.apply_friction()
				owner.face = 1
				owner.skid = false
	
	if Input.is_action_just_pressed("jump"):
		owner.velocity.y = owner.physics.speed_jump_get()
	
	owner.velocity.y -= owner.physics.speed_grv
	
	owner.velocity = owner.vector_to_global(owner.velocity)
	
	owner.move_and_slide()
	
	var to_local = func(): 
		owner.velocity = owner.vector_to_local(owner.velocity)
	to_local.call_deferred()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
