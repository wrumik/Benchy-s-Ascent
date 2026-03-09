class_name PlayerAttackItemResource
extends Resource

@export var icon_texture: Texture2D
@export var attack_scene: PackedScene
@export_range(1, 3) var category: int = 1
@export var attack_duration: float = 0.5
@export var attack_cooldown: int = 2
