extends Area3D

@export var velocidade: float
@export var life_time: float
@export var damage: float

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	audio.playing = true

func _process(delta: float) -> void:
	global_position += direction * velocidade * delta
	
	life_time -= delta
	if life_time <= 0:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
