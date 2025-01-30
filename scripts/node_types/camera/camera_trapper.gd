@tool
extends ReferenceRect
class_name CameraTrapper

@export var trap_extent: float = 0.0

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(0, 0, size.x, size.y).grow(trap_extent), border_color, false, 0.5)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		queue_redraw()
		return
	
	if get_global_rect().grow(trap_extent).has_point(Game.player.global_position):
		Game.player.camera.limit_left = global_position.x
		Game.player.camera.limit_right = global_position.x + size.x
		Game.player.camera.limit_top = global_position.y
		Game.player.camera.limit_bottom = global_position.y + size.y
	else:
		Game.player.camera.limit_left = global_position.x
		Game.player.camera.limit_right = global_position.x + size.x
		Game.player.camera.limit_top = global_position.y
		Game.player.camera.limit_bottom = global_position.y + size.y
