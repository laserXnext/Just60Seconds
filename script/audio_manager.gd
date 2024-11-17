extends Node

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if not  audio_stream_player.playing:
		audio_stream_player.play()

func pause_music():
	if audio_stream_player.playing:
		audio_stream_player.stop()

func resume_music():
	if not audio_stream_player.playing:
		audio_stream_player.play()
