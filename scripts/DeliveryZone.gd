extends Area2D

@export var order_manager_path: NodePath
@onready var order_manager = get_node(order_manager_path)
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var match_sounds: Array[AudioStream] = []

@export var cash_register_path: NodePath
@onready var cash_register = get_node(cash_register_path)

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.has_method("get_item_id") and body.get("item_id") == null:
		return

	var id = body.get("item_id")
	var matched = order_manager.try_fulfill(id)

	if matched:
		cash_register.AddMoney(id.length()) # OMg so lazy.
		_play_random_match_sound()
		body.queue_free()
	else:
		# optional: reject animation / sound
		pass

func _play_random_match_sound() -> void:
	if match_sounds.is_empty():
		return

	var chosen_sound = match_sounds[rng.randi_range(0, match_sounds.size() - 1)]
	audio_player.stream = chosen_sound
	audio_player.pitch_scale = rng.randf_range(.95, 1.05)
	audio_player.play()
