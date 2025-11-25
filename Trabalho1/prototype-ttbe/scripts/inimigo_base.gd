extends CharacterBody2D
class_name EnemyBase

signal inimigo_derrotado

@export var velocidade: float
@export var vida: int 

@onready var ponto_inicio: Vector2 = $Inicio.global_position
@onready var ponto_final: Vector2 = $Final.global_position

var indo_para_frente = true
var target: Vector2

func _ready() -> void:
	target = ponto_final;

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(target)
	global_position += direction * velocidade * delta
	
	var dist = global_position.distance_to(target)
	
	if dist < 5:
		if target == ponto_final:
			target = ponto_inicio
		else:
			target = ponto_final
		

func tomar_dano(value: int):
	vida -= value;
	if vida <= 0:
		emit_signal("inimigo_derrotado")
		queue_free()
