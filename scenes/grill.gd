extends Node2D

@onready var area: Area2D = $Area2D
@onready var grill_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var cooking_items: Dictionary = {}
# key = item instance
# value = elapsed cook time

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	var to_transform: Array = []

	for item in cooking_items.keys():
		if not is_instance_valid(item):
			to_transform.append(item)
			continue

		# optional: only cook when item is actually resting on grill
		cooking_items[item] += delta

		if cooking_items[item] >= item.grill_time:
			to_transform.append(item)

	for item in to_transform:
		if is_instance_valid(item) and item in cooking_items:
			if item.can_be_grilled():
				_transform_item(item)
		cooking_items.erase(item)

	_update_sound()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("items"):
		return

	if not (body is Item):
		return

	var item := body as Item
	if not item.can_be_grilled():
		return

	if item not in cooking_items:
		cooking_items[item] = 0.0

	_update_sound()

func _on_body_exited(body: Node) -> void:
	if body in cooking_items:
		cooking_items.erase(body)

	_update_sound()

func _transform_item(item: Item) -> void:
	var new_scene = ItemDatabase.get_scene(item.grill_result_id)
	if new_scene == null:
		push_warning("No scene found for item id: " + item.grill_result_id)
		return

	var parent = item.get_parent()
	var new_item = new_scene.instantiate()

	parent.add_child(new_item)
	new_item.global_position = item.global_position
	new_item.global_rotation = item.global_rotation

	if new_item is RigidBody2D:
		new_item.linear_velocity = item.linear_velocity
		new_item.angular_velocity = item.angular_velocity

	item.queue_free()

func _update_sound() -> void:
	if cooking_items.is_empty():
		if grill_sound.playing:
			grill_sound.stop()
	else:
		if not grill_sound.playing:
			grill_sound.play()
