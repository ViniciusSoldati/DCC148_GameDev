extends Node2D

@export var velocidade: float
@export var objeto : PackedScene
@export var num_objetos : int

var pool: ObjectPool
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pool = ObjectPool.new(objeto, num_objetos, "Bola")
	add_child(pool)
	screen_size = get_viewport_rect().size;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dy = Input.get_axis("cima", "baixo");
	var dx = Input.get_axis("esquerda", "direita");
	var translacao = Vector2(dx, dy).normalized() * velocidade * delta;
	translate(translacao);
	
	position.x = clamp(position.x, 25, screen_size.x - 25);
	position.y = clamp(position.y, 60, screen_size.y - 10);
	
	if(Input.is_action_just_pressed("atirar")):
		var bola = pool.get_from_pool()
		if bola:
			bola.global_position = global_position + Vector2(0, -120)
			bola.direction = Vector2.UP
			bola.active = true
			bola.bounce_count = 0
			
