extends CanvasLayer

@onready var bar: ProgressBar = $Control/ProgressBar
@onready var label: Label = $Control/Label

var camera: Camera2D
var camera_start_x: float
var victory_distance: float

func _process(_delta: float) -> void:
	if camera == null:
		print("camera nula")
		return
	
	var distance = camera.global_position.x - camera_start_x
	bar.value = clamp(distance/victory_distance, 0.0, 1.0)
	label.text = "Distância: " + str(int(distance)) + "m"
