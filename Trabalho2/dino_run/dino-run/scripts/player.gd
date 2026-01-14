extends CharacterBody2D

signal dead

@export var gravidade: float
@export var velocidade: float
@export var aceleracao: float
@export var max_velocidade: float
@export var forca_pulo: float
@export var offset_x: float

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $"../Camera2D"

var jump_count: int = 0;
var on_wall: bool = false

func _ready() -> void:
	anim.play("idle")
	global_position.x = camera.global_position.x - offset_x

func _physics_process(delta: float) -> void:
	out_limits()
	
	var dx = Input.get_axis("esquerda", "direita")
	velocidade = min(velocidade + aceleracao * delta, max_velocidade)
	
	var vet = Vector2(dx, 0) * velocidade * delta
	translate(vet)
	
	if not is_on_floor():
		velocity.y += gravidade * delta;
	elif on_wall != true and dx != 0:
		anim.play("run")
	
	if dx < 0:
		anim.flip_h = true
	elif dx > 0:
		anim.flip_h = false
	else:
		anim.play("idle")
		
	if Input.is_action_just_pressed("pular") and jump_count < 2:
		jump_count += 1;
		velocity.y = forca_pulo
		anim.play("jump")
	if is_on_floor():
		jump_count = 0;
	
	if is_on_wall() and on_wall == false:
		die()
	
	move_and_slide()

func die() -> void:
	emit_signal("dead")
	on_wall = true
	process_mode = Node.PROCESS_MODE_DISABLED
	anim.play("hit")

func out_limits() -> void:
	var viewport_width = get_viewport_rect().size.x
	var zoom_x = camera.zoom.x

	var left_limit = camera.global_position.x - (viewport_width * zoom_x) / 2
	if global_position.x < left_limit - 50.0 or global_position.y > 500.0:
		die()
