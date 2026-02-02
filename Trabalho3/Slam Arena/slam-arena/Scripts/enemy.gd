extends CharacterBody3D
signal enemy_dead


@export var velocidade: float
@export var detection_range: float
@export var health: float
@export var axe_damage: float
@export var gravidade: float

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var animation: AnimationPlayer = $"Skeleton_Warrior/AnimationPlayer"
@onready var axe: Node3D = $"Skeleton_Warrior/Rig_Medium/Skeleton3D/Right hand/Skeleton_Axe2"


var chasing: bool = false
var on_hit: bool = false
var is_dying: bool = false
var attacking: bool = false

func _ready() -> void:
	animation.animation_finished.connect(_on_animation_finished)
	axe.attack_player.connect(_on_attack_player)
	print(player)

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	if player == null:
		print("Inimigo desativado")
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity.y -= gravidade * delta
	else:
		velocity.y = 0
	
	if not on_hit and not attacking:
		if not chasing:
			animation.play("enemy/Idle_B")
		else:
			animation.play("enemy/Running_B")
	if attacking:
		animation.play("enemy/Melee_1H_Attack_Slice_Horizontal")
	
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= detection_range:
		chasing = true
		agent.target_position = player.global_position
		move_to(agent.target_position, delta)
	else:
		var dist_latest_target_position = global_position.distance_to(agent.target_position)
		if(dist_latest_target_position <= 0.5):
			navigation_finished()
	if distance <= 1.5:
		attack()
	
	move_and_slide()

func move_to(target: Vector3, delta: float) -> void:
	var dir: Vector3 = (target - global_position)
	dir.y = 0
	dir = dir.normalized()

	velocity.x = dir.x * velocidade
	velocity.z = dir.z * velocidade
	
	var target_yaw: float = atan2(dir.x, dir.z)
	rotation.y = lerp_angle(rotation.y, target_yaw, 6 * delta)
	agent.get_next_path_position()

func take_damage(damage: float):
	if not is_dying:
		on_hit = true
		animation.play("enemy/Hit_B")
		health -= damage
	if health <= 0.0:
		is_dying = true
		velocity = Vector3.ZERO
		animation.play("enemy/Death_B")

func die():
	emit_signal("enemy_dead")
	queue_free()

func _on_animation_finished(anim_name: String) -> void:
	if(anim_name == "enemy/Hit_B"):
		attacking = false
		on_hit = false
	elif(anim_name == "enemy/Death_B"):
		die()
	elif(anim_name == "enemy/Melee_1H_Attack_Slice_Horizontal"):
		attacking = false
		on_hit = false

func navigation_finished() -> void:
	velocity = Vector3.ZERO
	chasing = false

func _on_attack_player() -> void:
	player.take_damage(axe_damage)

func attack() -> void:
	if(on_hit):
		return
	attacking = true
	velocity = Vector3.ZERO
