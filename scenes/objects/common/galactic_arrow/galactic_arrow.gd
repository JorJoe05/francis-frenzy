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
	$RayCast2D.target_position = Vector2(scan_distance, 0)
	
	var black_material = StandardMaterial3D.new()
	black_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	black_material.albedo_color = Color.BLACK
	
	arrow = Sprite3D.new()
	arrow.texture = arrow_texture
	arrow.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
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
	orb_torus_large.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	orb_torus_large.position.z = orbit_radius_large
	orbit_torus_large.add_child(orb_torus_large)
	
	camera = Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 0.8
	camera.position.z = 1.0
	subviewport.add_child(camera)

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
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(arrow, "scale", (arrow.scale + Vector3.ONE).min(Vector3(max_scale, max_scale, max_scale)), anim_duration * (1.0/3.0))
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(arrow, "scale", Vector3(min_scale, min_scale, min_scale), anim_duration * (2.0/3.0))
	tween.tween_property(arrow, "scale", Vector3.ONE, 0.0)


func _on_player_hitbox_entered(hitbox: Hitbox2D) -> void:
	_animate()
	$AudioStreamPlayer2D.play()
	hitbox.owner.position = $RayCast2D.get_collision_point() - Vector2(16, 0).rotated(global_rotation)
	hitbox.owner.set_gravity(Vector2.LEFT.rotated(global_rotation))
	hitbox.owner.velocity = Vector2.ZERO
	hitbox.owner.reset_physics_interpolation()
