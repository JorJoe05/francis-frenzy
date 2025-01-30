@tool
extends Node2D

@export_group("Debug Draw", "debug")
@export var debug_show_line: bool = false
@export var debug_show_trajectory: bool = false
@export var debug_test_animation: bool = false:
	set(value):
		debug_test_animation = false
		if is_node_ready():
			_animate()

@export var launch_speed: float = 480.0:
	set(value):
		launch_speed = max(value, 0)
@export var launch_duration: float = 0.2:
	set(value):
		launch_duration = max(value, 0)

@onready var arrow: Node2D = $Arrow

@onready var star_texture = preload("res://sprites/common/spr_star_arrow_star.png")
@onready var sparkle_texture = preload("res://sprites/common/spr_star_arrow_sparkle.png")

var orbits_rotation = 0.0
var orbits_radius = 24.0
var orbits_speed = 1.0
var min_scale = 0.25
var max_scale = 2.0
var anim_duration = 0.5

var debug_draw_trajectory: float = 0.0:
	set(value):
		debug_draw_trajectory = wrapf(value, 0.0, max(launch_duration, 1.0))

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	pass

func _draw() -> void:
	if Engine.is_editor_hint():
		if debug_show_line:
			draw_line(Vector2(24, 0), (Vector2.RIGHT * (launch_speed * launch_duration)) + Vector2(24, 0), Color.RED, 1.0)
		if debug_show_trajectory:
			draw_circle(Vector2(debug_draw_trajectory * launch_speed, 0) + Vector2(24, 0), 2.0, Color.YELLOW)
	
	draw_set_transform(Vector2.ZERO, -global_rotation, Vector2.ONE)
	
	for orbit in range(0, 8):
		var interval = PI/4
		var texture = star_texture if orbit % 2 == 0 else sparkle_texture
		var offset = Vector2(orbits_radius, 0).rotated((interval * orbit) + orbits_rotation) - Vector2(4, 4)
		draw_texture(texture, offset)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		debug_draw_trajectory += delta
	
	orbits_rotation = wrapf(orbits_rotation + orbits_speed * delta, 0, PI*2)
	orbits_radius = move_toward(orbits_radius, 24, delta * 96)
	var blend = 1.0 - pow(0.5, delta * 2)
	orbits_speed = lerp(orbits_speed, 1.0, blend)
	
	queue_redraw()

func _animate() -> void:
	if Engine.is_editor_hint():
		pass
		#return
	orbits_speed = 20.0
	orbits_radius = 0.0
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(arrow, "scale", (arrow.scale + Vector2(1, 1)).min(Vector2(max_scale, max_scale)), anim_duration * (1.0/3.0))
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(arrow, "scale", Vector2(min_scale, min_scale), anim_duration * (2.0/3.0))
	tween.tween_property(arrow, "scale", Vector2.ONE, 0.0)


func _on_player_hitbox_entered(hitbox: Hitbox2D) -> void:
	_animate()
	$AudioStreamPlayer2D.play()
	hitbox.owner.state_machine.transition_to("Launch", {
		"launch_position": global_position + Vector2(24, 0).rotated(global_rotation),
		"launch_velocity": Vector2(launch_speed, 0).rotated(global_rotation), 
		"launch_duration": launch_duration
	})
	if abs(cos(rotation)) >= 0.1:
		hitbox.owner.face = sign(cos(rotation))
