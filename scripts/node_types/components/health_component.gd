@tool
class_name HealthComponent
extends Node

signal damaged(amount)
signal healed(amount)
signal depleted
signal maxed_out

@export var health : int = 5
@export var minimum_health : int = 0
@export var maximum_health : int = 5

func heal(amount: int = 1) -> void:
	if health == maximum_health:
		return
	var amount_healed : int = 0
	if health < maximum_health:
		while amount > 0 and health < maximum_health:
			amount -= 1
			amount_healed += 1
			health += 1
	healed.emit(amount_healed)
	if health == maximum_health:
		maxed_out.emit()
	print("Healed")

func damage(amount: int = 1) ->  void:
	if health == minimum_health:
		depleted.emit()
		return
	var amount_damaged : int = 0
	if health > minimum_health:
		while amount > 0 and health > minimum_health:
			amount -= 1
			amount_damaged += 1
			health -= 1
	damaged.emit(amount_damaged)
	print("Damaged")

func max_out() -> void:
	var amount = maximum_health - health
	heal(amount)
	print("Maxed Out")

func deplete() -> void:
	var amount = health - minimum_health
	damage(amount)

func is_full() -> bool:
	return health == maximum_health

func is_depleted() -> bool:
	return health == minimum_health
