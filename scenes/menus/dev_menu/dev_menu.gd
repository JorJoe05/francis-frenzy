extends Control

# var title = "res://Scenes/Menus/Title Screen/title_screen.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%BackButton.pressed.connect(_back)
	%BackButton.grab_focus()

func _back() -> void:
	pass#SceneManager.fade_scene_to_file(title, &"DevMenu")
