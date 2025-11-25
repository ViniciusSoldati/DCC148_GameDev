extends Node

@onready var vida: Control = $Hud/Health
var total_inimigos: int

func perder_vida() -> void:
	vida.perder_vida()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vida.connect("vida_acabou", Callable(self, "game_over"))
	
	var inimigos = get_tree().get_nodes_in_group("Inimigo")
	total_inimigos = inimigos.size()
	print("Inimigos no inicio: ", total_inimigos)
	
	for inimigo in inimigos:
		inimigo.connect("inimigo_derrotado", Callable(self, "ao_derrotar_inimigo"))

func game_over() -> void:
	get_tree().change_scene_to_file("res://cenas/game_over.tscn")

func ao_derrotar_inimigo() -> void:
	total_inimigos -= 1;
	print("Inimigos restantes: ", total_inimigos)
	
	if(total_inimigos <= 0):
		vitoria()

func vitoria() -> void:
	get_tree().change_scene_to_file("res://cenas/vitoria.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
