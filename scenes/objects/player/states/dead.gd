extends State

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	owner.apply_gravity()
	owner.move()
	#owner.collide()

func enter(_msg := {}) -> void:
	owner.ground_on = false
	owner.up_velocity = Vector2(0, -360)
	owner.hitbox.monitoring = false
	owner.hitbox.monitorable = false

func exit() -> void:
	pass
