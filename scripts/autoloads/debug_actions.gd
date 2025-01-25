extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		SceneManager.quit_to_title()

func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:
			KEY_F1:
				pass
			KEY_F2:
				pass
			KEY_F3:
				pass
			KEY_F4:
				pass
			KEY_F5:
				pass
			KEY_F6:
				pass
			KEY_F7:
				pass
			KEY_F8:
				pass
			KEY_F9:
				pass
			KEY_F10:
				pass
			KEY_F11:
				pass
			KEY_F12:
				SceneManager.quit_to_title()
				get_tree().root.set_input_as_handled()
