extends Entity

func _ready() -> void:
	$AnimatedSprite2D.play(&"default")

func _on_hitbox_type_filter_2d_hitbox_entered(hitbox: Hitbox2D) -> void:
	Game.player.process_mode - PROCESS_MODE_DISABLED
	Music.stop()
	Game.player.camera.process_mode = Node.PROCESS_MODE_ALWAYS
	Game.player.camera.get_pcam_host_owner().camera_2d.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D2.play(&"default")
	$AudioStreamPlayer2D.play()
	$PhantomCameraNoiseEmitter2D.emit()
	await get_tree().create_timer(1.0).timeout
	SceneManager.change_scene_to_file("res://title.tscn")
	Game.reset_player()
