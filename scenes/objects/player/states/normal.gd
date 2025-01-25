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
	var _speed_run = owner.physics.speed_run# if owner.dash > 0.0 else owner.physics.speed_run
	
	match int(sign(round(input.x))):
		-1:
			if owner.velocity.x > 0:
				owner.velocity.x += -_speed_dec
				if owner.ground_on:
					owner.skid = true
			else:
				if owner.velocity.x >= -_speed_run:
					owner.velocity.x = max(owner.velocity.x - _speed_acc, -_speed_run)
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
				if owner.velocity.x <= _speed_run:
					owner.velocity.x = min(owner.velocity.x + _speed_acc, _speed_run)
				else:
					owner.apply_friction()
				owner.face = 1
				owner.skid = false
	
	owner.velocity.y = min(owner.velocity.y + owner.physics.speed_grv, owner.physics.speed_fall)
	
	if Input.is_action_just_pressed("jump"):
		owner.velocity.y = owner.physics.speed_jump_get()
		owner.velocity.x += owner.ray_collider_bottom.get_collision().get_collider_velocity().x
		owner.ground_on = false
	if Input.is_action_just_released("jump"):
		owner.velocity.y = max(owner.velocity.y, owner.physics.speed_jump_release)
	
	owner.gravity_adjust_start()
	
	owner.position += owner.velocity / 60.0
	
	if owner.ground_on:
		owner.snap_floor()
	else:
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
