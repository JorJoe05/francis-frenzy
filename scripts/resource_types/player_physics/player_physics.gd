class_name PlayerPhysics
extends Resource

@export var speed_run: float = 4.0 * 60.0
@export var speed_dash: float = 6.0 * 60.0
@export var speed_dash_boost: float = 2.0 * 60.0
@export var dash_duration: float = 1.0
@export var speed_acc: float = 16
@export var speed_acc_air: float = 12
@export var speed_dec: float = 20
@export var speed_dec_air: float = 10
@export var speed_frc: float = 12
@export var speed_frc_air: float = 0.96875
@export var speed_grv: float = 16.0
@export var speed_fall: float = 6.0 * 60.0
@export var speed_jump_release: float = -2.0 * 60.0
@export var speed_hurt: float = -1.0 * 60.0
@export var jump_height: float = 80.0

func speed_jump_get() -> float:
	return -sqrt(2.0 * speed_grv * jump_height * 60.0)
