class_name BattleEnemy
extends Area2D

@export_group("enemy")
@export var health: int = 100
@export var defense: int = 0
@export var move_speed: float = 25.0
@export var decision_time: float = 1

var target_position: Vector2
var is_frozen: bool = true
var player: Area2D
var grid: CombatScene
var decision_timer: Timer


func _ready() -> void:
	get_tree().create_timer(1.5).timeout.connect(unfreeze)
	decision_timer = Timer.new()
	add_child(decision_timer)
	decision_timer.wait_time = decision_time
	decision_timer.timeout.connect(_on_decision_timer_timeout)


#freeze to not move while in animation
func unfreeze():
	is_frozen = false
	decision_timer.start()


func _process(delta: float) -> void:
	#smooth movement
	if !is_frozen:
		global_position = lerp(global_position, target_position, move_speed * delta)


func _on_decision_timer_timeout():
	pass
