class_name HitboxTypeFilter2D
extends Node

@export var type: StringName

var _parent

signal hitbox_entered(hitbox: Hitbox2D)
signal hitbox_exited(hitbox: Hitbox2D)
signal hitbox_shape_entered(hitbox_rid: RID, hitbox: Hitbox2D, hitbox_shape_index: int, local_shape_index: int)
signal hitbox_shape_exited(hitbox_rid: RID, hitbox: Hitbox2D, hitbox_shape_index: int, local_shape_index: int)

func _ready() -> void:
	_parent = get_parent()
	assert(_parent is Hitbox2D)
	
	_parent.hitbox_entered.connect(_on_parent_hitbox_entered)
	_parent.hitbox_exited.connect(_on_parent_hitbox_exited)
	_parent.hitbox_shape_entered.connect(_on_parent_hitbox_shape_entered)
	_parent.hitbox_shape_exited.connect(_on_parent_hitbox_shape_exited)

func _on_parent_hitbox_entered(hitbox: Hitbox2D) -> void:
	if hitbox.type == type:
		hitbox_entered.emit(hitbox)

func _on_parent_hitbox_exited(hitbox: Hitbox2D) -> void:
	if hitbox.type == type:
		hitbox_exited.emit(hitbox)

func _on_parent_hitbox_shape_entered(hitbox_rid: RID, hitbox: Hitbox2D, hitbox_shape_index: int, local_shape_index: int) -> void:
	if hitbox.type == type:
		hitbox_shape_entered.emit(hitbox_rid, hitbox, hitbox_shape_index, local_shape_index)

func _on_parent_hitbox_shape_exited(hitbox_rid: RID, hitbox: Hitbox2D, hitbox_shape_index: int, local_shape_index: int) -> void:
	if hitbox.type == type:
		hitbox_shape_exited.emit(hitbox_rid, hitbox, hitbox_shape_index, local_shape_index)

func get_overlapping_hitboxes() -> Array:
	var overlapping_hitboxes = _parent.get_overlapping_hitboxes()
	var out = []
	for hitbox in overlapping_hitboxes:
		if hitbox.type == type:
			out.append(hitbox)
	return out

func has_overlapping_hitboxes() -> bool:
	var overlapping_hitboxes = get_overlapping_hitboxes()
	return overlapping_hitboxes.size() > 0

func overlaps_hitbox(hitbox: Hitbox2D) -> bool:
	if hitbox.type == type:
		return true
	return false
