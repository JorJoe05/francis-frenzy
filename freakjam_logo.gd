extends ColorRect

func _ready() -> void:
	$TextureRect.modulate.a = 0
	
	var tween = create_tween()
	tween.tween_property($TextureRect, "modulate:a", 1.0, 0.25)
	await tween.finished
	
	await get_tree().create_timer(2.0).timeout
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($TextureRect, "position:x", $TextureRect.position.x - 32, 1.0)
	
	await get_tree().create_timer(0.75).timeout
	
	$Label.show()
	
	var tween2 = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property($Label, "rotation", 0, 0.25)
	
	var tween3 = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	tween3.tween_property($Label, "scale", Vector2.ONE, 0.25)
	tween3.set_trans(Tween.TRANS_LINEAR)
	tween3.tween_property($Label, "scale", Vector2(1.4, 0.6), 0.0)
	tween3.tween_property($Label, "scale", Vector2.ONE, 0.1)
	
	await get_tree().create_timer(2.0).timeout
	
	SceneManager.change_scene_to_file("res://title.tscn")
