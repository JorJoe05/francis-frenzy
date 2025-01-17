extends ReferenceRect
class_name CameraTrapper

@export var camera: PhantomCamera2D
@export var target_priority: int = 2

func _physics_process(delta: float) -> void:
	if get_rect().has_point(Game.player.position):
		camera.priority = target_priority
	else:
		camera.priority = 0
