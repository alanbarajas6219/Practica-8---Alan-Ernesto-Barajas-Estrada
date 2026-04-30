extends CanvasLayer

@onready var message_label: Label = $Panel/MessageLabel
@onready var coins_label: Label = $Panel/CoinsLabel
@onready var attempts_label: Label = $Panel/AttemptsLabel
@onready var best_score_label: Label = $Panel/BestScoreLabel
@onready var advice_label: Label = $Panel/AdviceLabel
@onready var api_effect_label: Label = $Panel/APIEffectLabel
@onready var controls_label: Label = $Panel/ControlsLabel

func update_coins(total: int) -> void:
	coins_label.text = "Monedas: %d" % total

func update_attempts(total: int) -> void:
	attempts_label.text = "Intentos: %d" % total

func update_best_score(best: int) -> void:
	best_score_label.text = "Mejor puntuación: %d" % best

func show_message(text: String) -> void:
	message_label.text = text

func clear_message() -> void:
	message_label.text = ""

func show_advice(text: String) -> void:
	advice_label.text = "Consejo API: " + text

func show_api_effect(text: String) -> void:
	api_effect_label.text = text

func show_game_over(total: int, best: int) -> void:
	message_label.text = "¡Choque! Monedas acumuladas: %d | Récord: %d" % [total, best]
