extends CanvasLayer

@onready var life_bar: ProgressBar = $LifeBar

func update_health(value: int):
	life_bar.value = value
