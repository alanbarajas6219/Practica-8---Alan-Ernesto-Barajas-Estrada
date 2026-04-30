extends Node

var total_collected: int = 0

func add_collectible(amount: int = 1) -> int:
	total_collected += amount
	return total_collected

func reset_session() -> void:
	total_collected = 0
