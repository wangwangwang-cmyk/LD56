extends CharacterBody2D

@export var speed := 5
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray: Ray = $Ray
@onready var wall_checker: RayCast2D = $G/WallChecker
@onready var g: Node2D = $G

enum Type{
	Type0,
	Type1,
	Type2,
}

enum Direction{
	LEFT = -1,
	RIGHT = 1,
}

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		default_dire.x = v
		g.scale.x = direction


var current_type := Type.Type0
var small_par = load("res://paramecium/small_paramecium.tscn")

var default_dire := Vector2.RIGHT

func _ready() -> void:
	animation_player.play("type0")

func _physics_process(delta: float) -> void:
	if wall_checker.is_colliding():
		direction *= -1
	default_dire.y = randf_range(-1, 1) * 100
	#print(default_dire.y)
	ray.get_coild()
	ray.calculate_final_result(default_dire, delta)
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
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
	speed += 5
	for i in 2:
		var body_shape = $G/BodyBox.get_children()[i]
		body_shape.set_deferred("disabled", true)
	if current_type > 2:
		var x = 1
		Music.play_sfx("Coin")
		#print("分裂")
		for i in 2:
			GameData.smallParamecium_count += 2
			var new_small_par = small_par.instantiate()
			get_tree().root.call_deferred("add_child",new_small_par)
			var body_shape = $G/BodyBox.get_children()[i]
			new_small_par.global_position = Vector2(body_shape.global_position.x + x * 15,body_shape.global_position.y)
			new_small_par.get_node("G").scale.x *= x
			x *= -1
		call_deferred("queue_free")
		GameData.parame_count -= 1
	await get_tree().create_timer(0.1).timeout
	var r = randi_range(0, 100)
	var time_direction = 1 if r >= 50 else -1
	velocity.x += time_direction * 100
	for i in 2:
		var body_shape = $G/BodyBox.get_children()[i]
		body_shape.set_deferred("disabled", false)
	pass # Replace with function body.


func _on_body_box_area_entered(area: Area2D) -> void:
	Music.play_sfx("Die")
	GameData.smallParamecium_count += 1
	GameData.parame_count -= 1
	var new_small_par = small_par.instantiate()
	get_tree().root.call_deferred("add_child",new_small_par)
	new_small_par.global_position = self.global_position
	call_deferred("queue_free")
	pass # Replace with function body.
