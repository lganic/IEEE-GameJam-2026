extends Area2D

@export var move_speed: float = 250.0

var target_area: Area2D
var follow_offset: Vector2 = Vector2(0, -10)

@export var resource_type = "nothing"

var player: Node2D = null

var bacon
var biscuit
var bread
var jazza
var zorp
var snargle

func _ready() -> void:
	bacon = get_tree().get_first_node_in_group("bacon-dispenser")
	biscuit = get_tree().get_first_node_in_group("biscuit-dispenser")
	bread = get_tree().get_first_node_in_group("bun-dispenser")
	jazza = get_tree().get_first_node_in_group("jazza-dispenser")
	zorp = get_tree().get_first_node_in_group("zorp-dispenser")
	snargle = get_tree().get_first_node_in_group("snargle-dispenser")

func start_following() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		queue_free()
		return
	
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if player == null:
		return
	
	global_position = player.global_position + follow_offset

func _on_area_entered(area: Area2D) -> void:
	if area == target_area:
		on_reached_target()
		queue_free()

func on_reached_target() -> void:
	print("Reached target!")

	if resource_type == "bacon":
		bacon.quant += 5
	elif resource_type == "biscuit":
		biscuit.quant += 5
	elif resource_type == "bread":
		bread.quant += 5
	elif resource_type == "jazza":
		jazza.quant += 5
	elif resource_type == "zorp":
		zorp.quant += 5
	elif resource_type == "snargle":
		snargle.quant += 5
