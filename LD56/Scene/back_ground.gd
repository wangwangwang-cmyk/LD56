extends ColorRect

@onready var num: Label = %num
@export var para_num := 15 

@onready var parame: Node2D = $parame
@onready var end_label: Label = $Control2/EndLabel
@onready var control_2: Control = $Control2

var baby_area_min := Vector2(15, 25)
var baby_area_max := Vector2(240, 135)
var load_para = load("res://paramecium/paramecium.tscn")

func _ready() -> void:
	GameData.count_change.connect(_update_label)
	GameData.end.connect(_end)
	_update_label()
	_ins_para()
	control_2.hide()
	pass

func _update_label() -> void:
	num.text = "Count: " + str(GameData.smallParamecium_count)
	pass

func _ins_para() -> void:
	for i in para_num:
		var ins_para = load_para.instantiate()
		parame.add_child(ins_para)
		ins_para.global_position = Vector2(
		randf_range(baby_area_min.x,baby_area_max.x),
		randf_range(baby_area_min.y,baby_area_max.y)
		)


func _on_quit_area_entered(area: Area2D) -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().call_deferred("reload_current_scene")
	GameData.smallParamecium_count = 0
	GameData.parame_count = 15
	pass # Replace with function body.

func _end() -> void:
	control_2.show()
	end_label.text = "You helped " + str(GameData.smallParamecium_count) +" paramecies. THX"
	pass
