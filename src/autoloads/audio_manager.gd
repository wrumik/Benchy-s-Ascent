extends Node2D

var current_song: AudioStreamPlayer
@onready var sound_effects: Node2D = $SoundEffects
@onready var music: Node = $Music

func play_audio(audio_name: String):
	var audio_to_play: AudioStreamPlayer = sound_effects.get_node(audio_name.to_lower())
	audio_to_play.play()


func play_audio_at_position(audio_name: String, pos: Vector2):
	if !get_node(audio_name.to_lower()) is AudioStreamPlayer2D:
		printerr("not a valid 2D audio")
		return
	var audio_to_play: AudioStreamPlayer2D = sound_effects.get_node(audio_name.to_lower())
	audio_to_play.global_position = pos
	audio_to_play.play()


func play_music(song_name: String):
	current_song = get_node(song_name.to_lower())
	music.current_song.play()
	current_song.finished.connect(play_music)


func stop_music():
	current_song.stop()
