extends Node2D

@export var chunk_scenes: Array[PackedScene]
@export var chunk_width: int
@export var victory_distance: float
@export var victory_chunk: PackedScene

@onready var camera: Camera2D = $'../Camera2D'

var start_x: float = 0.0
var next_x = 0
var victory_spawned: bool = false
var forced_next_chunk: PackedScene = null
var victory_chunk_instance: VictoryChunk


func _ready() -> void:
	start_x = camera.global_position.x
	spawn_safe_chunk()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not victory_spawned and get_distance() >= victory_distance:
		spawn_victory_chunk()
		victory_spawned = true
	
	if camera.global_position.x + chunk_width > next_x and not victory_spawned:
		spawn_chunk()
	
	remove_chunk()

func spawn_chunk() -> void:
	var chunk_scene: PackedScene
	if forced_next_chunk != null:
		chunk_scene = forced_next_chunk
		forced_next_chunk = null
	else:
		chunk_scene = chunk_scenes.pick_random()
	
	var chunk = chunk_scene.instantiate()
	chunk.global_position = Vector2(next_x, 0)
	add_child(chunk)
	
	if chunk is ChunkBase and chunk.next_force_chunk != null:
		forced_next_chunk = chunk.next_force_chunk
	
	next_x += chunk_width
	
func remove_chunk() -> void:
	for chunk in get_children():
		if chunk.global_position.x + chunk_width < camera.global_position.x - chunk_width:
			chunk.queue_free()

func spawn_safe_chunk() -> void:
	var safe_chunk = chunk_scenes[0].instantiate()
	safe_chunk.global_position = Vector2(next_x, 0)
	add_child(safe_chunk)
	next_x += chunk_width

func get_distance() -> float:
	return camera.global_position.x - start_x

func spawn_victory_chunk() -> void:
	victory_chunk_instance = victory_chunk.instantiate()
	victory_chunk_instance.global_position = Vector2(next_x, 0)
	add_child(victory_chunk_instance)
	next_x += chunk_width
