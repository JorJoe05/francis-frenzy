extends Entity
class_name ScreamWave

var life: int = 6

@export var init_speed: float = 480.0

func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(sprite.rotation) * init_speed

func _physics_process(delta: float) -> void:
	sprite.rotation = velocity.angle()
	sprite.modulate = Color(1.0, float(life)/5.0, float(life)/5.0)
	
	position += velocity / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")
	
	if ray_collider_bottom.bounce():
		life -= 1
		#%Scream.play()
	
	if ray_collider_top.bounce():
		life -= 1
		#%Scream.play()
	
	if ray_collider_left.bounce():
		life -= 1
		#%Scream.play()
	
	if ray_collider_right.bounce():
		life -= 1
		#%Scream.play()
	
	if life < 0:
		queue_free()

func _on_screen_exited() -> void:
	queue_free()
