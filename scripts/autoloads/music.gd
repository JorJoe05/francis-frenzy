extends Node

var _audio_stream_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_audio_stream_player = AudioStreamPlayer.new()
	_audio_stream_player.bus = &"Music"
	add_child(_audio_stream_player)

func set_stream(_stream: AudioStream) -> void:
	if _audio_stream_player.stream != _stream:
		_audio_stream_player.stop()
		_audio_stream_player.stream = _stream
		_audio_stream_player.play()

func get_stream() -> AudioStream:
	return _audio_stream_player.stream

func stop() -> void:
	if _audio_stream_player.playing:
		_audio_stream_player.stop()
		_audio_stream_player.stream = null
