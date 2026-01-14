extends Node

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var hud: CanvasLayer = $Hud
@onready var chunk_manager: Node2D = $Chunk_manager
@onready var music: AudioStreamPlayer = $BGM

func _ready() -> void:
	player.connect("dead", on_player_dead)
	music.play()
	hud.camera = camera
	hud.camera_start_x = camera.global_position.x
	hud.victory_distance = chunk_manager.victory_distance

func _process(_delta: float) -> void:
	var vc = $Chunk_manager.victory_chunk_instance
	if vc != null:
		vc.connect("player_victory", on_player_victory)
		set_process(false)

func on_player_victory() -> void:
	print("VITÓRIA")
	player.anim.play("idle")
	camera.process_mode = Node.PROCESS_MODE_DISABLED

func on_player_dead() -> void:
	music.stop()
