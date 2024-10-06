extends Control

@export var bgm:AudioStream

func _ready() -> void:
	if bgm:
		Music.play_bgm(bgm)
