class_name BattleEnemy
extends Area2D

@export_group("enemy")
@export var move_speed: float = 25.0

var target_position: Vector2
var is_frozen: bool = true
signal move_to(current_pos: Vector2, direction: Vector2)

func _ready() -> void:
	get_tree().create_timer(1.5).timeout.connect(unfreeze)

func unfreeze():
	is_frozen = false

func _process(delta: float) -> void:
	#smooth movement
	if !is_frozen:
		global_position = lerp(global_position, target_position, move_speed * delta)
