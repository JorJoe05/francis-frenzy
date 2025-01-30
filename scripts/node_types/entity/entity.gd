extends CharacterBody2D
class_name Entity

#region Signals

signal ground_enter
signal ground_exit
signal ceiling_hit
signal flipped(_face)

#endregion

#region Enums

enum Face {
	LEFT = -1,
	RIGHT = 1
}

#endregion

#region Exports

@export var face: Face = 1:
	set(value):
		if value != 0 and value != face:
			face = sign(value)
			flipped.emit(face)
			_flip(face)

@export_group("Nodes")

@export_subgroup("Ray Colliders")
@export var collider_root: Node2D
@export var ray_collider_top: RayCollider
@export var ray_collider_bottom: RayCollider
@export var ray_collider_left: RayCollider
@export var ray_collider_right: RayCollider

@export_subgroup("Hitboxes")
@export var hitbox: Hitbox2D

@export_subgroup("Visuals")
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree
var animation_state_machine:
	get:
		if animation_tree:
			return animation_tree.get(&"parameters/playback")
@export var sprite_root: Node2D
@export var sprite: Node2D

#endregion

var local_velocity: Vector2
var up_relative_velocity: Vector2:
	set(value):
		velocity = value.rotated((up_direction.angle() + (PI/2)))
	get:
		return velocity.rotated(-(up_direction.angle() + (PI/2)))

var previous_position: Vector2
var position_delta: Vector2

var previous_global_position: Vector2
var global_position_delta: Vector2

var previous_face: int = face

var normal: Vector2 = Vector2.UP
var ground_on: bool = true:
	set(value):
		if value != ground_on:
			if value == true:
				ground_enter.emit()
			if value == false:
				ground_exit.emit()
		ground_on = value

#region System Functions

func _set(property: StringName, value: Variant) -> bool:
	match property:
		_:
			return false

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			pass
		NOTIFICATION_PHYSICS_PROCESS:
			position_delta = position - previous_position
			previous_position = position
			global_position_delta = global_position - previous_global_position
			previous_global_position = global_position
			previous_face = face
		NOTIFICATION_PROCESS:
			_animate.call_deferred()

func _animate() -> void:
	if sprite_root:
		sprite_root.scale.x = face

func _flip(_face: Face) -> void:
	pass

func move():
	if ground_on:
		velocity = local_velocity.rotated((-normal.orthogonal()).angle())
	
	position += velocity / 60.0

func collide():
	if ground_on:
		ground_on = ray_collider_bottom.snap()
		normal = ray_collider_bottom.get_collision().get_normal()
	else:
		ground_on = ray_collider_bottom.collide()
		normal = up_direction
		
	ray_collider_top.collide()
	
	if ray_collider_left.collide():
		local_velocity.x = max(local_velocity.x, 0)
	if ray_collider_right.collide():
		local_velocity.x = min(local_velocity.x, 0)

func apply_gravity():
	up_relative_velocity.y = min(up_relative_velocity.y + 16.0, 360)

#endregion

func rotated_to_up(vector: Vector2) -> Vector2:
	var angle = up_direction.angle() + (PI/2)
	return vector.rotated(-angle)

func rotated_from_up(vector: Vector2) -> Vector2:
	var angle = up_direction.angle() + (PI/2)
	return vector.rotated(angle)
