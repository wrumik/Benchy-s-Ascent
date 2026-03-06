extends Control

@onready var pause_menu: CenterContainer = $CanvasLayer/PauseMenu
@onready var resume_button: TextureButton = $CanvasLayer/PauseMenu/VBoxContainer/ResumeButton
@onready var enemies: Node2D = $CanvasLayer/CombatScene/CombatGrid/Enemies
@onready var animation_player: AnimationPlayer = $CanvasLayer/CombatScene/CombatGrid/AnimationPlayer

var placeholder_battle_resource: BattleResource = preload("res://src/resources/test.tres")

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


func ready_battle(_battle_resource: BattleResource):
	animation_player.play("start_of_battle")


func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ready_battle(placeholder_battle_resource)
