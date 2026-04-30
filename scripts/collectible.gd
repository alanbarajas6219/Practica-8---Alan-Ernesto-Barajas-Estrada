extends Area3D

signal picked(value: int)

@export var value: int = 1
@export var rotate_speed: float = 2.8
@export var float_height: float = 0.16
@export var float_speed: float = 3.0

var picked_up: bool = false
var base_y: float = 0.0
var time_alive: float = 0.0

@onready var visual: Node3D = $Visual
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var pickup_sound: AudioStreamPlayer3D = $PickupSound

func _ready() -> void:
	add_to_group("collectible")
	base_y = visual.position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if picked_up:
		return

	time_alive += delta
	visual.rotate_y(rotate_speed * delta)
	visual.position.y = base_y + sin(time_alive * float_speed) * float_height

func _on_body_entered(body: Node3D) -> void:
	if picked_up:
		return

	if body.is_in_group("player"):
		picked_up = true
		picked.emit(value)
		collision_shape.disabled = true
		visual.visible = false
		pickup_sound.play()
		await get_tree().create_timer(0.25).timeout
		queue_free()
