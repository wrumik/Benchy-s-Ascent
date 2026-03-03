extends Node2D

@onready var player_character: CharacterBody2D = $PlayerCharacter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

var samurai_enemy = preload("res://src/scenes/delete_this.tscn")
var enemy_array = []

func _ready() -> void:
	enemy_array.append(samurai_enemy)


func enter_battle(enemies: Array):
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	enter_battle(enemy_array)
