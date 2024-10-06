extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var cut_position :Vector2
var tween :Tween

func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _unhandled_input(event: InputEvent) -> void:
	if animation_player.is_playing():
		return
	if event.is_action_pressed("cut"):
		cut_position = global_position
		animation_player.play("cut")
		Music.play_sfx("Cut")
		# 播放音效
	pass

func _process(delta: float) -> void:
	if not animation_player.is_playing():
		tween = create_tween()
		tween.tween_property(self,"global_position",get_global_mouse_position(), 1.5)
	else:
		var new_tween = create_tween()
		new_tween.tween_property(self,"global_position",cut_position, 0.1)
	#global_position = get_global_mouse_position()
	

