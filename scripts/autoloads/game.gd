extends Node

func _ready() -> void:
	player = load("res://scenes/objects/player/player.tscn").instantiate()
	PlayerContainer.add_child(player)

func reset_player() -> void:
	player.queue_free()
	player = load("res://scenes/objects/player/player.tscn").instantiate()
	PlayerContainer.add_child(player)

var player: Player
