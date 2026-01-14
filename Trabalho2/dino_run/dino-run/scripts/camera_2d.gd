extends Camera2D

@export var velocidade: float
@export var aceleracao: float
@export var max_velocidade: float
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	player.connect("dead", on_player_dead)


func _process(delta: float) -> void:
	velocidade = min(velocidade + aceleracao * delta, max_velocidade)
	position.x += velocidade * delta

func on_player_dead() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
