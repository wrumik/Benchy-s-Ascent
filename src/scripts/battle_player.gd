extends Area2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

@export var grid: CombatScene

signal update_health

var is_attacking: bool = false
var is_dead: bool = false
var target_position: Vector2
var player_move_speed: float = 25.0

var slot_1_attack: PlayerAttackItemResource
var slot_2_attack: PlayerAttackItemResource
var slot_3_attack: PlayerAttackItemResource
var attack_1_cooldown: float = 0.0
var attack_2_cooldown: float = 0.0
var attack_3_cooldown: float = 0.0

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
		if !is_attacking:
			if Input.is_action_just_pressed("left"):
				grid.move_player_to_tile(Vector2(-1, 0))
			if Input.is_action_just_pressed("right"):
				grid.move_player_to_tile(Vector2(1, 0))
			if Input.is_action_just_pressed("up"):
				grid.move_player_to_tile(Vector2(0, -1))
			if Input.is_action_just_pressed("down"):
				grid.move_player_to_tile(Vector2(0, 1))
		if Input.is_action_just_pressed("attack_1"):
			use_attack(slot_1_attack)
		if Input.is_action_just_pressed("attack_2"):
			use_attack(slot_2_attack)
		if Input.is_action_just_pressed("attack_3"):
			use_attack(slot_3_attack)
		if Input.is_action_just_pressed("attack_ultimate"):
			pass


func use_attack(attack_resource: PlayerAttackItemResource):
	is_attacking = true
	var attack_instance: Node2D = attack_resource.attack_scene.instantiate()
	add_sibling(attack_instance)
	attack_instance.global_position = global_position
	await get_tree().create_timer(attack_resource.attack_duration).timeout
	is_attacking = false



func _process(delta: float) -> void:
	global_position = lerp(global_position, target_position, player_move_speed * delta)
