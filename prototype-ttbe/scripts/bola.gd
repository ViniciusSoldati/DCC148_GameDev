extends CharacterBody2D

@export var velocidade: float
var active: bool = false
var direction: Vector2
var bounce_count: int = 0
var max_bounce: int = 10

func desativar_bola() -> void:
	active = false;
	hide();
	set_physics_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not active:
		return
	
	var desloc = direction * velocidade * delta;
	var colisao = move_and_collide(desloc);
	
	if(colisao):
		var collider = colisao.get_collider()
		
		if collider.name == "Chao":
			var root = get_tree().current_scene
			root.perder_vida()
			desativar_bola()
			return
		
		if collider.is_in_group("Inimigo"):
			var normal = (global_position - collider.global_position).normalized()
			collider.tomar_dano(1);
			direction = direction.bounce(normal)
		else:
			direction = direction.bounce(colisao.get_normal())
			
		bounce_count += 1
		if bounce_count >= max_bounce:
			desativar_bola()
			return
