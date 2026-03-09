class_name BattleEnemy
extends StaticBody2D

@export_group("enemy")
@export var health: int = 100
@export var defense: int = 0
@export var move_speed: float = 25.0
@export var decision_time: float = 1

var target_position: Vector2
var player: Area2D
var grid: CombatScene
var decision_timer: Timer


func _ready() -> void:
	decision_timer = Timer.new()
	decision_timer.wait_time = decision_time
	decision_timer.timeout.connect(_on_decision_timer_timeout)
	add_child(decision_timer)
	decision_timer.start()

func _process(delta: float) -> void:
	#smooth movement
	global_position = lerp(global_position, target_position, move_speed * delta)


func _on_decision_timer_timeout():
	pass


func take_damage(amount: int):
	health -= amount
	if health <= 0:
		queue_free()
