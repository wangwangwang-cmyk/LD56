extends CharacterBody2D

signal die

enum Direction{
	LEFT = -1,
	RIGHT = 1,
}

@export var direction := Direction.RIGHT:
	set(v):
		direction = v
		default_dire.x = v
		g.scale.x = direction
		

@export var speed := 20

@onready var g: Node2D = $G
@onready var ray: Ray = $Ray
@onready var wall_checker: RayCast2D = $G/WallChecker

var default_dire := Vector2(1, 0)

func _ready() -> void:
	GameData.smallParamecium_count += 1
	var r = randi_range(0, 100)
	direction = Direction.RIGHT if r >= 50 else Direction.LEFT
	$AnimationPlayer.play("idle")
	pass

func _physics_process(delta: float) -> void:
	if wall_checker.is_colliding():
		direction *= -1
	default_dire.y = randf_range(-1, 1) * 100
	#print(default_dire.y)
	ray.get_coild()
	ray.calculate_final_result(default_dire, delta)
	move_and_slide()


func _on_body_box_area_entered(area: Area2D) -> void:
	#print("die")
	GameData.smallParamecium_count -= 1
	Music.play_sfx("Die")
	call_deferred("queue_free")
	die.emit()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	var r = randi_range(0, 100)
	var time_direction = 1 if r >= 50 else -1
	velocity.x += time_direction * 100
	pass # Replace with function body.
