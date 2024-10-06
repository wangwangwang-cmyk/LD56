class_name Ray
extends Node2D

@export_range(1, 32) var target_layer_number :int = 1
@export var ray_length :int = 10

var num_rays := 8

var interset: Array[float]
var danger: Array[float]
var contest_map: Array
# 引导参数，值越小转弯越圆滑
var steering_force_vaule := 0.5
var get_ray :Array
var interest_dire :Array[Vector2] = [
	Vector2.DOWN, Vector2(1, 1), Vector2.RIGHT, Vector2(1, -1),
	Vector2.UP, Vector2(-1, -1), Vector2.LEFT, Vector2(-1, 1)
]

func _ready() -> void:
	init_attribute()
	

func init_attribute() -> void:
	# 初始化数组
	get_ray = get_children()
	danger.resize(num_rays)
	#danger.fill(0.0)
	interset.resize(num_rays)
	contest_map.resize(num_rays)
	_ray_set_mask(target_layer_number)
	for i in get_ray:
		i.target_position *= ray_length
	pass

# 放在_physics_process中执行
# 射线发生碰撞时，给对应方向的危险数组元素赋值
func get_coild() -> void:
	for i in get_ray:
		if i.is_colliding():
			var new_i = get_ray.find(i)
			danger[new_i] = 5
			danger[(new_i + 1)% danger.size()] = 2
			danger[(new_i - 1)% danger.size()] = 2
			if owner is CharacterBody2D:
				owner.velocity -= interest_dire[new_i]
			else:
				print_debug("拥有者有问题")
		else:
			danger[get_ray.find(i)] = 0

func calculate_final_result(owner_target_dire:Vector2, delta:float) -> void:
	for i in num_rays:
		interset[i] = owner_target_dire.dot(interest_dire[i])
		contest_map[i] = interset[i] - danger[i]
	# 计算最佳方向
	var max_index = contest_map.find(contest_map.max())
	if owner is CharacterBody2D:
		var steering_force = interest_dire[max_index] * owner.speed - owner.velocity
		owner.velocity = owner.velocity + steering_force * delta * steering_force_vaule
	else:
		print_debug("拥有者有问题")
	pass


func _ray_set_mask(layer_number: int) -> void:
	for i in get_ray:
		i.set_collision_mask_value(1, false)
		i.set_collision_mask_value(layer_number, true)
	pass
