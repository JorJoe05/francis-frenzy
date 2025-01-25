@tool
extends Entity

@export var floating: bool = false
@export var rise_speed: float = 128.0
@export var rise_peak: float = 64.0
@export var rise_delay: float = 2.0
@export var fall_delay: float = 2.0

@onready var _global_rise_base_init: float = global_position.y
var _global_rise_base: float:
	get:
		return _global_rise_base_init + (sin(_delay * 2) * 2)

@onready var _global_rise_peak_init: float = global_position.y - rise_peak
var _global_rise_peak: float:
	get:
		return _global_rise_peak_init + (sin(_delay * 2) * 2)

var _state: StringName = &"Fall"
var _delay: float = 0.0
var _falling: bool = false

@export var size: int = 1:
	set(value):
		size = max(value, 1)
		$Platform.size.x = 32 + (24 * (size - 1))
		$Platform.position.x = -$Platform.size.x / 2
		$CollisionShape2D.shape.size.x = $Platform.size.x

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2(-$Platform.size.x / 2, -32 - rise_peak), Vector2($Platform.size.x / 2, -32 - rise_peak), Color.RED)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	match _state:
		&"Fall":
			if floating:
				velocity.y = lerp(velocity.y, clampf((_global_rise_base - global_position.y) * 5.0, -rise_speed, rise_speed), 0.125)
			else:
				velocity.y += 12.0
			if _delay >= fall_delay:
				_delay = 0
				_state = &"Rise"
		&"Rise":
			velocity.y = lerp(velocity.y, clampf((_global_rise_peak - global_position.y) * 5.0, -rise_speed, rise_speed), 0.125)
			if _delay >= rise_delay:
				_delay = 0
				_falling = true
				_state = &"Fall"
	
	move_and_slide()
	
	if ray_collider_bottom.detect():
		if _falling:
			_falling = false
			velocity.y = -120
		else:
			velocity.y = 0
		position += ray_collider_bottom.get_collision().get_snap_delta()
	
	_delay += delta
