extends Node

var enemy_scene_dict: Dictionary[String, PackedScene] = {}

var is_in_battle: bool = false
var player_max_health: int = 100
var player_health: int = 100
var player_defense: int = 0

func _ready() -> void:
	for i in DirAccess.get_files_at("res://src/scenes/enemies/"):
		enemy_scene_dict.set(i.get_basename(), load("res://src/scenes/enemies/" + i))
