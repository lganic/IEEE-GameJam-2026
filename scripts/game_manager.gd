extends Node

@export var world_camera_path: NodePath
@export var cooking_camera_path: NodePath
@export var ordering_camera_path: NodePath

var is_cooking = false
var is_ordering = false

var player
var player_pos

@onready var world_camera: Camera2D = get_node(world_camera_path)
@onready var cooking_camera: Camera2D = get_node(cooking_camera_path)
@onready var ordering_camera: Camera2D = get_node(ordering_camera_path)

func _ready() -> void:

	player = get_tree().get_first_node_in_group("player")

	activate_ordering() # Default to the ordering screen, so we can get that intro animation.
	call_deferred("_delayed_world") # Hacky workaround to send to world once intro done

func _process(dt) -> void:
	
	if is_ordering or is_cooking:
		player.global_position = player_pos

func _delayed_world() -> void:
	await get_tree().create_timer(15.0).timeout
	activate_world()
	
	
func activate_ordering() -> void:
	
	player_pos = player.global_position
	
	is_ordering = true
	is_cooking = false
	
	world_camera.enabled = false
	cooking_camera.enabled = false
	ordering_camera.enabled = true
	
func activate_cooking() -> void:
	
	player_pos = player.global_position
	
	is_ordering = false
	is_cooking = true
	
	world_camera.enabled = false
	cooking_camera.enabled = true
	ordering_camera.enabled = false
	
func activate_world() -> void:

	is_ordering = false
	is_cooking = false
	
	world_camera.enabled = true
	cooking_camera.enabled = false
	ordering_camera.enabled = false

func toggle_ordering() -> void:

	if is_ordering:
		activate_world()
	else:
		activate_ordering()
			
func toggle_cooking() -> void:
	
	if is_cooking:
		activate_world()
	else:
		activate_cooking()
