extends Node2D


func play_audio(audio_name: String):
	var audio_to_play: AudioStreamPlayer = get_node(audio_name)
	audio_to_play.play()
