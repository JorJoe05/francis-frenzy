extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	owner.apply_gravity()
	owner.move()
	owner.collide()
	
	if owner.ground_on:
		state_machine.transition_to(&"Normal")

func enter(_msg := {}) -> void:
	#if owner.health.is_depleted():
	#	state_machine.transition_to(&"Dead")
	#	return
	owner.ground_on = false
	owner.up_velocity = Vector2(-_msg.face * 120, -240)

func exit() -> void:
	pass
