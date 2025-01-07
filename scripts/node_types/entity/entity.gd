extends CharacterBody2D
class_name Entity

var ground_on: bool = true

func vector_to_local(vector: Vector2) -> Vector2:
	var angle = up_direction.angle() + (PI/2)
	return vector.rotated(-angle)

func vector_to_global(vector: Vector2) -> Vector2:
	var angle = up_direction.angle() + (PI/2)
	return vector.rotated(angle)
