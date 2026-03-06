extends Node

var enemy_scene_dict: Dictionary[String, PackedScene] = {}

func _ready() -> void:
	for i in DirAccess.get_files_at("res://src/scenes/enemies/"):
		enemy_scene_dict.set(i.get_basename(), load("res://src/scenes/enemies/" + i))
