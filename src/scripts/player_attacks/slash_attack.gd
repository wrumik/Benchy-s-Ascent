extends Area2D

@export var damage: int = 25

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(queue_free)


func _on_body_entered(body: Node2D) -> void:
	if body is BattleEnemy:
		body.take_damage(damage)
