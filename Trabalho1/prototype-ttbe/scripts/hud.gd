extends Control

signal vida_acabou

@onready var barra: ProgressBar = $ProgressBar
@export var valor_barra: float

func _ready() -> void:
	barra.max_value = valor_barra
	barra.value = valor_barra

func perder_vida() -> void:
	valor_barra = max(valor_barra - 10, 0)
	barra.value = valor_barra
	
	if(valor_barra == 0):
		game_over()

func game_over() -> void:
	emit_signal("vida_acabou")
