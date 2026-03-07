extends Node2D

@export var battle_file_path: String = "res://src/battles/test_battle.json"


func interact():
	print("interacted")
	PlayerUI.start_battle(battle_file_path)
