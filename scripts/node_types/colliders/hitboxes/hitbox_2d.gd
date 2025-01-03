class_name Hitbox2D
extends Area2D

@export var type: StringName

signal hitbox_entered(hitbox: Hitbox2D)
signal hitbox_exited(hitbox: Hitbox2D)
signal hitbox_shape_entered(hitbox_rid: RID, hitbox: Hitbox2D, hitbox_shape_index: int, local_shape_index: int)
signal hitbox_shape_exited(hitbox_rid: RID, hitbox: Hitbox2D, hitbox_shape_index: int, local_shape_index: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)
	area_shape_entered.connect(_area_shape_entered)
	area_shape_exited.connect(_area_shape_exited)

func _area_entered(area) -> void:
	if area is Hitbox2D:
		hitbox_entered.emit(area)

func _area_exited(area) -> void:
	if area is Hitbox2D:
		hitbox_exited.emit(area)

func _area_shape_entered(area_rid, area, area_shape_index, local_shape_index) -> void:
	if area is Hitbox2D:
		hitbox_shape_entered.emit(area_rid, area, area_shape_index, local_shape_index)

func _area_shape_exited(area_rid, area, area_shape_index, local_shape_index) -> void:
	if area is Hitbox2D:
		hitbox_shape_exited.emit(area_rid, area, area_shape_index, local_shape_index)

func get_overlapping_hitboxes() -> Array:
	var overlapping_areas = get_overlapping_areas()
	var out = []
	for area in overlapping_areas:
		if area is Hitbox2D:
			out.append(area)
	return out

func has_overlapping_hitboxes() -> bool:
	var overlapping_hitboxes = get_overlapping_hitboxes()
	return overlapping_hitboxes.size() > 0

func overlaps_hitbox(hitbox: Hitbox2D) -> bool:
	return overlaps_area(hitbox)
