extends Node3D
signal attack_player

@onready var attack_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_area_3d_body_entered(_body: Node3D) -> void:
	emit_signal("attack_player")

func play_attack_sound() -> void:
	attack_sound.playing = true
