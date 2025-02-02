extends Entity
class_name Enemy

@export var walk_speed: float = 60.0
@export var yorbs: int = 5

var _is_dead: bool = false

func _flip(_face: Face) -> void:
	animation_state_machine.travel(&"turn")

func _ready() -> void:
	up_direction = Vector2.UP.rotated(rotation)
	if walk_speed == 0:
		animation_state_machine.start(&"idle")
	else:
		animation_state_machine.start(&"walk")
	$Hitbox2D/PlayerFilter.hitbox_entered.connect(_hit, CONNECT_ONE_SHOT)
	if get_parent() is LoaderRect:
		$VisibleOnScreenEnabler2D.queue_free()
		process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not _is_dead:
		_normal(delta)
	else:
		_dead(delta)

func _normal(delta: float) -> void:
	velocity = -walk_speed * face * up_direction.orthogonal()
	
	apply_gravity()
	move()
	if ray_collider_left.collide():
		face = Face.RIGHT
	if ray_collider_right.collide():
		face = Face.LEFT
	if not ray_collider_bottom.snap():
		face = -face
	ray_collider_top.collide()

func _dead(delta: float) -> void:
	apply_gravity()
	move()
	if collide():
		_destroy()

func _hit(_hitbox: Hitbox2D) -> void:
	if _hitbox.owner is Player:
		_hitbox.owner.up_velocity.y = min(-abs(_hitbox.owner.up_velocity.y), -360)
	ground_on = false
	var _face = sign((_hitbox.owner.global_position - global_position).dot(-up_direction.orthogonal()))
	if _face != 0: face = _face
	velocity = Vector2(-240 * face, -240).rotated((-up_direction.orthogonal()).angle())
	self.hitbox.types[0] = &"Enemy_Dead"
	animation_state_machine.travel(&"hurt")
	_is_dead = true

func _destroy() -> void:
	Game.player.yorbs += yorbs
	if _is_dead:
		var explosion = load("res://scenes/objects/effects/real_explosion.tscn").instantiate()
		explosion.position = global_position
		get_tree().current_scene.add_child(explosion)
		queue_free()
