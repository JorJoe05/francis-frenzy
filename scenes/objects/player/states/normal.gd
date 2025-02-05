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
	
	var input = owner.get_rotated_input_vector()
	
	var _speed_dec = owner.physics.speed_dec if owner.ground_on else owner.physics.speed_dec_air
	var _speed_acc = owner.physics.speed_acc if owner.ground_on else owner.physics.speed_acc_air
	var _speed_run = owner.physics.speed_run# if owner.dash > 0.0 else owner.physics.speed_run
	
	match owner.ground_on:
		true:
			owner.local_velocity.y = 0
			
			match int(sign(round(input.x))):
				-1:
					if owner.local_velocity.x > 0:
						owner.local_velocity.x += -_speed_dec
						owner.skid = true
					else:
						if owner.local_velocity.x >= -_speed_run:
							owner.local_velocity.x = max(owner.local_velocity.x - _speed_acc, -_speed_run)
						else:
							owner.friction_ground()
						owner.face = -1
						owner.skid = false
				0:
					owner.friction_ground()
				1:
					if owner.local_velocity.x < 0:
						owner.local_velocity.x += _speed_dec
						owner.skid = true
					else:
						if owner.local_velocity.x <= _speed_run:
							owner.local_velocity.x = min(owner.local_velocity.x + _speed_acc, _speed_run)
						else:
							owner.friction_ground()
						owner.face = 1
						owner.skid = false
		false:
			match int(sign(round(input.x))):
				-1:
					if owner.up_velocity.x > 0:
						owner.up_velocity.x += -_speed_dec
					else:
						if owner.up_velocity.x >= -_speed_run:
							owner.up_velocity.x = max(owner.up_velocity.x - _speed_acc, -_speed_run)
						else:
							owner.friction_air()
						owner.face = -1
						owner.skid = false
				0:
					owner.friction_air()
				1:
					if owner.up_velocity.x < 0:
						owner.up_velocity.x += _speed_dec
					else:
						if owner.up_velocity.x <= _speed_run:
							owner.up_velocity.x = min(owner.up_velocity.x + _speed_acc, _speed_run)
						else:
							owner.friction_air()
						owner.face = 1
						owner.skid = false
	
	if Input.is_action_just_pressed("jump"):
		owner.pepsi = true
	if owner.can_jump():
		%Jump.play()
		owner.ground_on = false
		owner.pepsi = true
		owner.up_velocity.y = owner.physics.speed_jump_get()

	if Input.is_action_just_pressed("scream"):
		owner.scream()
	
	owner.apply_gravity()
	if not Input.is_action_pressed("jump") and owner.up_velocity.y < owner.physics.speed_jump_release:
		owner.apply_gravity()
	owner.move()
	owner.collide()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
