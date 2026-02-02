extends Node

@export var victory_scene: PackedScene
@onready var player = $Player
@onready var hud = $Hud

var enemy_count: int
var enemies = []

func _ready() -> void:
	enemies = get_tree().get_nodes_in_group("enemy")
	enemy_count = enemies.size()
	print(enemy_count)
	
	for enemy in enemies:
		enemy.connect("enemy_dead", on_enemy_dead)
	
	hud.life_bar.max_value = player.max_health
	hud.update_health(player.current_health)

	player.connect("health_changed", Callable(hud, "update_health"))

func on_enemy_dead() -> void:
	enemy_count -= 1
	print("Inimigos restantes: ", enemy_count)
	if enemy_count <= 0:
		victory()

func victory() -> void:
	print("VOCE VENCEU")
