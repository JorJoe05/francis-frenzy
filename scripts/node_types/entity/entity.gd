extends CharacterBody2D
class_name Entity

#region Signals

signal ground_enter
signal ground_exit
signal ceiling_hit

#endregion

#region Exports

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
@export var sprite_root: Node2D

#endregion

var local_velocity: Vector2
var previous_position: Vector2

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
			previous_position = position
		NOTIFICATION_PROCESS:
			_animate()

func _animate() -> void:
	pass

#endregion

func vector_to_local(vector: Vector2) -> Vector2:
	var angle = up_direction.angle() + (PI/2)
	return vector.rotated(-angle)

func vector_to_global(vector: Vector2) -> Vector2:
	var angle = up_direction.angle() + (PI/2)
	return vector.rotated(angle)
