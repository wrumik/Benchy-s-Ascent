extends Control

@onready var pause_menu: CenterContainer = $CanvasLayer/PauseMenu
@onready var resume_button: TextureButton = $CanvasLayer/PauseMenu/VBoxContainer/ResumeButton
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var combat_scene: PackedScene

var combat_instance: CombatScene


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("pause"):
			match pause_menu.visible:
				true:
					pause_menu.hide()
					get_tree().paused = false
				false:
					pause_menu.show()
					resume_button.grab_focus()
					get_tree().paused = true


func start_battle(battle_file_path: String):
	if combat_instance == null:
		combat_instance = combat_scene.instantiate()
		canvas_layer.add_child(combat_instance)
		combat_instance.ready_battle(battle_file_path)
		GameData.is_in_battle = true


func end_battle():
	if combat_instance != null:
		combat_instance.queue_free()
		GameData.is_in_battle = false
