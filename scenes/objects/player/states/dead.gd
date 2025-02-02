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
	Music.stop()
	%Death.play()
	owner.ground_on = false
	owner.up_velocity = Vector2(0, -360)
	owner.hitbox.monitoring = false
	owner.hitbox.monitorable = false
	await get_tree().create_timer(1.0).timeout
	SceneManager.change_scene_to_file("res://title.tscn")
	Game.reset_player()

func exit() -> void:
	pass
