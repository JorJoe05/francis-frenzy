extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("yorb")

func collect() -> void:
	reset_physics_interpolation()
	$AnimatedSprite2D.play("collect")
	$AudioStreamPlayer2D.play()
	await $AnimatedSprite2D.animation_finished
	#reparent(get_tree().root)
	queue_free()

func _on_player_entered(hitbox: Hitbox2D) -> void:
	collect()
	Game.player.yorbs += 1
