extends Entity
class_name Enemy

@export var walk_speed: float = 1.0

var _face: int = 1
var _is_dead: bool = false

func _ready() -> void:
	velocity.x = walk_speed * _face

func _physics_process(delta: float) -> void:
	if not _is_dead:
		_normal(delta)
	else:
		_dead(delta)

func _normal(delta: float) -> void:
	velocity.y += 0.2
	
	velocity.x = walk_speed * _face
	
	position += velocity
	
	if not $Floor.snap():
		_face = -_face
		$AnimatedSprite2D.flip_h = _face == -1
	
	if $Left.detect():
		_face = 1
		$AnimatedSprite2D.flip_h = false
	
	if $Right.detect():
		_face = -1
		$AnimatedSprite2D.flip_h = true

func _dead(delta: float) -> void:
	velocity.y += 0.2
	position += velocity
	if $Floor.detect():
		_destroy()

func _hit(hitbox: Hitbox2D) -> void:
	ground_on = false
	_face = -sign(hitbox.owner.position.x - position.x)
	velocity = Vector2(2 * _face, -4)
	$Hitbox2D.type = &"Enemy_Dead"
	$AnimatedSprite2D.play("hurt")
	_is_dead = true

func _destroy() -> void:
	if _is_dead:
		var explosion = load("res://scenes/objects/effects/real_explosion.tscn").instantiate()
		explosion.position = global_position
		get_tree().current_scene.add_child(explosion)
		queue_free()
