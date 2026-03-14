extends Area2D

@export var spawned_scene: PackedScene
@export var target_area_path: NodePath
@export var follow_offset: Vector2 = Vector2(0, -40)
@export var spawn_cooldown: float = 0.2

var can_spawn := true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not can_spawn:
		return

	if not body.is_in_group("player"):
		return

	can_spawn = false
	call_deferred("_spawn_haul_object")
	
	if spawn_cooldown > 0.0:
		await get_tree().create_timer(spawn_cooldown).timeout
	
	can_spawn = true

func _spawn_haul_object() -> void:
	var spawned = spawned_scene.instantiate()
	get_tree().current_scene.add_child(spawned)

	spawned.target_area = get_node(target_area_path)
	spawned.follow_offset = follow_offset
	spawned.start_following()
