extends Area2D

@export var game_manager_path: NodePath
var player_in_range := false

@onready var game_manager = get_node(game_manager_path)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	
	if player_in_range and Input.is_action_just_pressed("interact"):
		game_manager.toggle_cooking()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
