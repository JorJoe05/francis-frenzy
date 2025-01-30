extends CanvasLayer

func fade_in() -> void:
	$ColorRect.color.a = 0.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "color:a", 1.0, 0.2)
	await tween.finished

func fade_out() -> void:
	$ColorRect.color.a = 1.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "color:a", 0.0, 0.2)
	await tween.finished
