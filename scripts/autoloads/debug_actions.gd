extends Node

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
				var thal = func(): Globals.current_character = Enums.CurrentCharacter.THAL
				var boki = func(): Globals.current_character = Enums.CurrentCharacter.BOKI
				DialogManager.create_dialog("Change Character", ["Thal", "Boki", "Cancel"], [thal, boki, Callable()], "Thal")
				get_tree().root.set_input_as_handled()
			KEY_F12:
				var title = func(): SceneManager.quit_to_title()
				DialogManager.create_confirmation_dialog("Quit to dev menu?", true, title, Callable())
				get_tree().root.set_input_as_handled()
