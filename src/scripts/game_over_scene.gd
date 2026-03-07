extends Control


func _ready() -> void:
	await get_tree().create_timer(5).timeout
	SceneManager.change_scene_to_file("res://src/scenes/main_menu.tscn")
