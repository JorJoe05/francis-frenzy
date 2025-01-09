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
	
	#owner.ground_on = owner.is_on_floor()
	
	var input = Input.get_vector("left", "right", "down", "up")
	input = owner.vector_to_global(input)
	
	var _speed_dec = owner.physics.speed_dec if owner.ground_on else owner.physics.speed_dec_air
	var _speed_acc = owner.physics.speed_acc if owner.ground_on else owner.physics.speed_acc_air
	
	match int(sign(round(input.x))):
		-1:
			if owner.velocity.x > 0:
				owner.velocity.x += -_speed_dec
				if owner.ground_on:
					owner.skid = true
			else:
				if owner.velocity.x >= -owner.physics.speed_run:
					owner.velocity.x = max(owner.velocity.x - _speed_acc, -owner.physics.speed_run)
				else:
					owner.apply_friction()
				owner.face = -1
				owner.skid = false
		0:
			owner.apply_friction()
		1:
			if owner.velocity.x < 0:
				owner.velocity.x += _speed_dec
				if owner.ground_on:
					owner.skid = true
			else:
				if owner.velocity.x <= owner.physics.speed_run:
					owner.velocity.x = min(owner.velocity.x + _speed_acc, owner.physics.speed_run)
				else:
					owner.apply_friction()
				owner.face = 1
				owner.skid = false
	
	owner.velocity.y = min(owner.velocity.y + owner.physics.speed_grv, owner.physics.speed_fall)
	
	if Input.is_action_just_pressed("jump"):
		owner.velocity.y = owner.physics.speed_jump_get()
		owner.ground_on = false
	
	owner.gravity_adjust_start()
	
	owner.position += owner.velocity / 60.0
	
	#owner.snap_floor()
	owner.collide_floor()
	owner.collide_ceiling()
	owner.collide_walls()
	
	owner.gravity_adjust_end()
	
	

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
