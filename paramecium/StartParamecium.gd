extends CharacterBody2D

enum Type{
	Type0,
	Type1,
	Type2,
}


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_type := Type.Type0


func _ready() -> void:
	animation_player.play("type0")

func _on_start_area_area_entered(area: Area2D) -> void:
	current_type += 1
	print_debug(current_type)
	match current_type:
		Type.Type0:
			animation_player.play("type0")
			pass
		Type.Type1:
			animation_player.play("type1")
			pass
		Type.Type2:
			animation_player.play("type2")
			pass
	Music.play_sfx("Hurt")
	if current_type > 2:
		get_tree().call_deferred("change_scene_to_file","res://Scene/back_ground.tscn")
	pass # Replace with function body.
