extends Node2D
class_name VictoryChunk

signal player_victory

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("player_victory")
