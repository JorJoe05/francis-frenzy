extends Control


func _on_button_pressed() -> void:
	SceneManager.change_scene_to_file("res://scenes/levels/fruit/lvl_fruit_01.tscn")


func _on_button_2_pressed() -> void:
	SceneManager.change_scene_to_file("res://scenes/levels/moon/lvl_moon_01.tscn")
