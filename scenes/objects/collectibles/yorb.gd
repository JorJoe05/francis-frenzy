extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("yorb")

func collect() -> void:
	$AnimatedSprite2D.play("collect")
	$AudioStreamPlayer2D.play()
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_player_entered(hitbox: Hitbox2D) -> void:
	collect()
	hitbox.owner.yorbs += 1
