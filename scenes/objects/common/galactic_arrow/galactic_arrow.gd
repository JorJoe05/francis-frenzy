@tool
extends Node2D

@export_group("Debug Draw", "debug")
@export var debug_test_animation: bool = false:
	set(value):
		debug_test_animation = value
		if is_node_ready():
			_animate()

@export var scan_distance: float = 128.0:
	set(value):
		scan_distance = value
		$RayCast2D.target_position = Vector2(scan_distance, 0)
@export var force_face: bool = false
@export var face: Entity.Face = 1

@onready var subviewport = $SubViewport
@onready var render = $Render
var arrow
var orbit_torus_small
var orb_torus_small
var orbit_torus_large
var orb_torus_large
var camera

@onready var arrow_texture = preload("res://sprites/common/spr_galactic_arrow.png")
@onready var orb_texture = preload("res://sprites/common/spr_galactic_arrow_orb.png")

var orbit_radius_small = 0.25
var orbit_radius_large = 0.3
var orbit_speed = 1.0

var min_scale = 0.25
var max_scale = 2.0
var anim_duration = 0.5

func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		queue_free()
		return
	$RayCast2D.target_position = Vector2(scan_distance, 0)
	
	var black_material = StandardMaterial3D.new()
	black_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	black_material.albedo_color = Color.CYAN
	
	arrow = Sprite3D.new()
	arrow.texture = arrow_texture
	arrow.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	arrow.no_depth_test = true
	arrow.render_priority = 1
	subviewport.add_child(arrow)
	
	orbit_torus_small = CSGTorus3D.new()
	orbit_torus_small.inner_radius = orbit_radius_small - 0.005
	orbit_torus_small.outer_radius = orbit_radius_small + 0.005
	orbit_torus_small.sides = 32
	orbit_torus_small.ring_sides = 8
	orbit_torus_small.material = black_material
	orbit_torus_small.rotation_order = EULER_ORDER_ZXY
	subviewport.add_child(orbit_torus_small)
	
	orb_torus_small = Sprite3D.new()
	orb_torus_small.texture = orb_texture
	orb_torus_small.billboard = true
	orb_torus_small.no_depth_test = true
	orb_torus_small.render_priority = 1
	orb_torus_small.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	orb_torus_small.position.z = orbit_radius_small
	orbit_torus_small.add_child(orb_torus_small)
	
	orbit_torus_large = CSGTorus3D.new()
	orbit_torus_large.inner_radius = orbit_radius_large - 0.005
	orbit_torus_large.outer_radius = orbit_radius_large + 0.005
	orbit_torus_large.sides = 32
	orbit_torus_large.ring_sides = 8
	orbit_torus_large.material = black_material
	orbit_torus_large.rotation_order = EULER_ORDER_ZXY
	subviewport.add_child(orbit_torus_large)
	
	orb_torus_large = Sprite3D.new()
	orb_torus_large.texture = orb_texture
	orb_torus_large.billboard = true
	orb_torus_large.no_depth_test = true
	orb_torus_large.render_priority = 1
	orb_torus_large.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	orb_torus_large.position.z = orbit_radius_large
	orbit_torus_large.add_child(orb_torus_large)
	
	camera = Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 1.2
	camera.position.z = 1.5
	subviewport.add_child(camera)

func _draw() -> void:
	if force_face and Engine.is_editor_hint():
		draw_line(Vector2.ZERO, Vector2(0, -face * 24), Color.RED, 1.0)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	
	rotation = snapped(rotation, PI/2)
	
	render.rotation = -global_rotation
	
	arrow.rotation.z = -global_rotation
	
	orbit_torus_small.rotation.x = wrapf(orbit_torus_small.rotation.x + orbit_speed * 1.00 * delta, 0, PI*2)
	orbit_torus_small.rotation.y = wrapf(orbit_torus_small.rotation.y + orbit_speed * 2.00 * delta, 0, PI*2)
	orbit_torus_small.rotation.z = wrapf(orbit_torus_small.rotation.z + orbit_speed * 0.50 * delta, 0, PI*2)
	
	orbit_torus_large.rotation.x = wrapf(orbit_torus_large.rotation.x + orbit_speed * -0.50 * delta, 0, PI*2)
	orbit_torus_large.rotation.y = wrapf(orbit_torus_large.rotation.y + orbit_speed * -1.00 * delta, 0, PI*2)
	orbit_torus_large.rotation.z = wrapf(orbit_torus_large.rotation.z + orbit_speed * -0.25 * delta, 0, PI*2)
	
	var blend = 1.0 - pow(0.5, delta * 2)
	orbit_speed = lerp(orbit_speed, 1.0, blend)
	
	queue_redraw()

func _animate() -> void:
	if Engine.is_editor_hint():
		pass
		#return
	orbit_speed = 20.0
	
	var scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(arrow, "scale", Vector3(1.8, 1.2, 2), anim_duration * (0.5/3.0))
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.tween_property(arrow, "scale", Vector3.ONE, anim_duration * (2.0/3.0))
	scale_tween.set_trans(Tween.TRANS_LINEAR)
	scale_tween.tween_property(arrow, "scale", Vector3(0.6, 1.4, 1.0), 0.0)
	scale_tween.tween_property(arrow, "scale", Vector3.ONE, (0.5/3.0))
	
	var position_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	position_tween.tween_property(arrow, "position", Vector3(0.16, 0, 0).rotated(Vector3.FORWARD, global_rotation), anim_duration * (0.5/3.0))
	position_tween.set_ease(Tween.EASE_IN)
	position_tween.tween_property(arrow, "position", Vector3(0, 0, 0), anim_duration * (2.0/3.0))
	position_tween.set_trans(Tween.TRANS_LINEAR)
	position_tween.tween_property(arrow, "position", Vector3(-0.06, 0, 0).rotated(Vector3.FORWARD, global_rotation), 0.0)
	position_tween.tween_property(arrow, "position", Vector3(0, 0, 0), (0.5/3.0))


func _on_player_hitbox_entered(hitbox: Hitbox2D) -> void:
	_animate()
	$AudioStreamPlayer2D.play()
	$Trail.size.x = abs($RayCast2D.get_collision_point() - global_position).length()
	$AnimationPlayer.stop()
	$AnimationPlayer.play(&"fire")
	
	var set_flash = func(val: float) -> void: hitbox.owner.sprite_root.material.set_shader_parameter(&"flash_mix", val)
	var tween = create_tween()
	tween.tween_method(set_flash, 1.0, 0.0, 0.5)
	
	if hitbox.owner.up_direction.dot(Vector2.LEFT.rotated(global_rotation)) < -0.75:
		hitbox.owner.face *= -1
	if force_face:
		hitbox.owner.face = face
	
	hitbox.owner.ground_on = false
	hitbox.owner.pepsi = true
	
	$PhantomCameraNoiseEmitter2D.emit()
	
	hitbox.owner.position = $RayCast2D.get_collision_point() - Vector2(16, 0).rotated(global_rotation)
	hitbox.owner.up_direction = Vector2.LEFT.rotated(global_rotation)
	hitbox.owner.velocity = Vector2.ZERO
	hitbox.owner.local_velocity = Vector2.ZERO
	hitbox.owner.rotation = Vector2.UP.rotated(global_rotation).angle()
	hitbox.owner.reset_physics_interpolation()
