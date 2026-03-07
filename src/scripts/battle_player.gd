extends Area2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

signal update_health

var is_dead: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Hazard:
		take_damage(body.damage_amount)


func take_damage(amount):
	AudioManager.play_audio("damage")
	GameData.player_health -= (amount - GameData.player_defense)
	update_health.emit()
	if GameData.player_health <= 0:
		is_dead = true
		player_sprite.play("death")
		await player_sprite.animation_finished
		PlayerUI.end_battle()
		SceneManager.change_scene_to_file("res://src/scenes/game_over_scene.tscn")
	else:
		player_sprite.play("damage")
		await player_sprite.animation_finished
		player_sprite.play("combat_ready")
