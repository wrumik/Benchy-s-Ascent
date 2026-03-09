extends Area2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

@export var grid: CombatScene

signal update_health

var is_dead: bool = false
var target_position: Vector2
var player_move_speed: float = 25.0

func _ready() -> void:
	if grid == null:
		push_error("No grid connected to the player node.")


func _on_body_entered(body: Node2D) -> void:
	if body is Hazard:
		take_damage(body.damage_amount)


func take_damage(amount):
	if !is_dead:
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


func _input(_event: InputEvent) -> void:
	if !is_dead:
		if Input.is_action_just_pressed("left"):
			grid.move_player_to_tile(Vector2(-1, 0))
		if Input.is_action_just_pressed("right"):
			grid.move_player_to_tile(Vector2(1, 0))
		if Input.is_action_just_pressed("up"):
			grid.move_player_to_tile(Vector2(0, -1))
		if Input.is_action_just_pressed("down"):
			grid.move_player_to_tile(Vector2(0, 1))


func _process(delta: float) -> void:
	global_position = lerp(global_position, target_position, player_move_speed * delta)
