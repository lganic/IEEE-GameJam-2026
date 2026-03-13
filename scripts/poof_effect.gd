extends Node2D

@export var cloud_texture: Texture2D
@export var cloud_count: int = 5
@export var radius: float = 18.0
@export var lifetime: float = 0.45
@export var min_scale: float = 0.5
@export var max_scale: float = 1.0
@export var poof_sound: AudioStream

var sprites: Array[Sprite2D] = []
var velocities: Array[Vector2] = []
var age := 0.0

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	randomize()

	if poof_sound != null:
		audio_player.stream = poof_sound
		audio_player.play()

	for i in cloud_count:
		var sprite = Sprite2D.new()
		sprite.texture = cloud_texture
		sprite.centered = true
		sprite.z_index = 100

		var angle = randf() * TAU
		var dist = randf_range(4.0, radius)
		sprite.position = Vector2.RIGHT.rotated(angle) * dist

		var scale_value = randf_range(min_scale, max_scale)
		sprite.scale = Vector2.ONE * scale_value
		sprite.modulate.a = 0.95

		add_child(sprite)
		sprites.append(sprite)

		var speed = randf_range(20.0, 60.0)
		velocities.append(Vector2.RIGHT.rotated(angle) * speed)

func _process(delta: float) -> void:
	age += delta
	var t = age / lifetime

	for i in sprites.size():
		var sprite = sprites[i]
		sprite.position += velocities[i] * delta
		sprite.scale += Vector2.ONE * delta * 0.8
		sprite.modulate.a = lerp(0.95, 0.0, t)

	if age >= lifetime:
		queue_free()
