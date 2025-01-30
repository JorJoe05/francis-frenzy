extends CanvasLayer

func fade_in_up() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect.anchor_bottom = 0.0
	$ColorRect2.color.a = 0.0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($ColorRect, "anchor_bottom", 1.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 1.0, 0.2)
	await tween.finished

func fade_out_up() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect2.color.a = 1.0
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($ColorRect, "anchor_top", 1.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 0.0, 0.2)
	await tween.finished

func fade_in_down() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect.anchor_top = 1.0
	$ColorRect2.color.a = 0.0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($ColorRect, "anchor_top", 0.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 0.0, 0.2)
	await tween.finished

func fade_out_down() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect2.color.a = 1.0
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($ColorRect, "anchor_bottom", 0.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 0.0, 0.2)
	await tween.finished

func fade_in_left() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect.anchor_right = 0.0
	$ColorRect2.color.a = 0.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "anchor_right", 1.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 1.0, 0.2)
	await tween.finished

func fade_out_left() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect2.color.a = 1.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "anchor_left", 1.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 0.0, 0.2)
	await tween.finished

func fade_in_right() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect.anchor_left = 1.0
	$ColorRect2.color.a = 0.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "anchor_left", 0.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 1.0, 0.2)
	await tween.finished

func fade_out_right() -> void:
	$ColorRect.set_anchors_preset(Control.PRESET_FULL_RECT)
	$ColorRect2.color.a = 1.0
	var tween = create_tween()
	tween.tween_property($ColorRect, "anchor_right", 0.0, 0.2)
	var fade_tween = create_tween()
	fade_tween.tween_property($ColorRect2, "color:a", 0.0, 0.2)
	await tween.finished
