extends CharacterBody3D
signal health_changed(current_health)

@export var velocidade: float
@export var gravidade: float
@export var mouse_sensitivity: float
@export var min_pitch: float
@export var max_pitch: float
@export var fire_rate: float
@export var projectile_scene: PackedScene
@export var max_health: float

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var skin: Node3D = $Rogue
@onready var animation: AnimationPlayer = $Rogue/AnimationPlayer
@onready var shootPoint: Marker3D = $ShootPoint


var mouse_delta: Vector2 = Vector2.ZERO
var can_shoot: bool = true
var current_health: float

func _ready() -> void:
	current_health = max_health
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation.animation_finished.connect(_on_animation_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	if Input.is_action_just_pressed("shoot"):
		shoot()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravidade * delta
	else:
		velocity.y = 0
	
	var input_dir: Vector3 = Vector3.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_back")
	input_dir.normalized()
	
	if(can_shoot):
		if input_dir == Vector3.ZERO:
			animation.play("player/Idle_B")
		else:
			animation.play("player/Running_B")
	
	var cam_yaw: float = spring_arm.global_rotation.y
	var yaw_basis: Basis = Basis(Vector3.UP, cam_yaw)
	var direction: Vector3 = yaw_basis * input_dir
	direction = direction.normalized()

	velocity.x = direction.x * velocidade
	velocity.z = direction.z * velocidade
	
	rotate_y(-mouse_delta.x * mouse_sensitivity)
	spring_arm.rotate_x(-mouse_delta.y * mouse_sensitivity)
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, min_pitch, max_pitch)
	
	mouse_delta = Vector2.ZERO
	
	move_and_slide()

func shoot() -> void:
	if not can_shoot:
		return
	
	can_shoot = false
	animation.play("player/Ranged_1H_Shoot")
	await get_tree().create_timer(0.35).timeout
	
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	var dir: Vector3 = -shootPoint.global_transform.basis.z
	dir.normalized()
	
	projectile.global_position = shootPoint.global_position
	projectile.direction = dir
	
	projectile.look_at(projectile.global_position + dir, Vector3.UP)
	
	await get_tree().create_timer(fire_rate).timeout

func _on_animation_finished(anim_name: String) -> void:
	if(anim_name == "player/Ranged_1H_Shoot"):
		can_shoot = true

func take_damage(enemy_damage: float):
	current_health -= enemy_damage
	current_health = max(current_health, 0)
	emit_signal("health_changed", current_health)
	
	if(current_health <= 0):
		queue_free()
	
