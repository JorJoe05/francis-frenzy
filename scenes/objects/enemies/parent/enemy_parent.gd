extends Entity
class_name Enemy

@export var walk_speed: float = 60.0

var _is_dead: bool = false

func _flip(_face: Face) -> void:
	animation_state_machine.travel(&"turn")

func _ready() -> void:
	up_direction = Vector2.UP.rotated(rotation)
	animation_state_machine.start(&"walk")
	$Hitbox2D/PlayerFilter.hitbox_entered.connect(_hit, CONNECT_ONE_SHOT)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not _is_dead:
		_normal(delta)
	else:
		_dead(delta)

func _normal(delta: float) -> void:
	velocity -= 16.0 * up_direction
	
	velocity = -walk_speed * face * up_direction.orthogonal()
	
	position += velocity / 60.0
	
	if not $Floor.snap():
		face = -face
	
	if $Left.detect():
		face = 1
	
	if $Right.detect():
		face = -1

func _dead(delta: float) -> void:
	velocity -= 16.0 * up_direction
	position += velocity / 60.0
	if $Floor.detect():
		_destroy()

func _hit(_hitbox: Hitbox2D) -> void:
	ground_on = false
	face = sign(_hitbox.owner.position.x - position.x)
	velocity = Vector2(-240 * face, -240).rotated((-up_direction.orthogonal()).angle())
	self.hitbox.types[0] = &"Enemy_Dead"
	animation_state_machine.travel(&"hurt")
	_is_dead = true

func _destroy() -> void:
	if _is_dead:
		var explosion = load("res://scenes/objects/effects/real_explosion.tscn").instantiate()
		explosion.position = global_position
		get_tree().current_scene.add_child(explosion)
		queue_free()
