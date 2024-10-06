extends Node

signal count_change
signal end

var smallParamecium_count := 0:
	set(v):
		smallParamecium_count = v
		count_change.emit()

var parame_count := 15:
	set(v):
		parame_count = v
		if parame_count <= 0:
			print_debug("end")
			end.emit()
