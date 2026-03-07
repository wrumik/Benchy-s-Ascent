extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func change_scene_to_file(scene: String):
	get_tree().paused = true
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	get_tree().paused = false
	animation_player.play("FadeOut")


func change_scene_to_packed(scene: PackedScene):
	get_tree().paused = true
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(scene)
	get_tree().paused = false
	animation_player.play("FadeOut")
