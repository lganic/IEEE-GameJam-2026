extends Node
class_name RecipeManager

@export var poof_effect_scene: PackedScene
@export var check_interval: float = 0.2

var recipes = [
	{
		"inputs": ["bun", "cooked_patty", "bun"],
		"output": "burger"
	}
]

var timer := 0.0

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= check_interval:
		timer = 0.0
		check_recipes()

func check_recipes() -> void:
	var all_items: Array[Item] = []
	for node in get_tree().get_nodes_in_group("items"):
		if node is Item:
			all_items.append(node)

	var used: Array[Item] = []

	for item in all_items:
		if item in used:
			continue
		if has_item_below(item, all_items):
			continue

		var stack = build_stack_from_bottom(item, all_items)

		if stack.size() < 2:
			continue

		if not stack_is_stable(stack):
			continue

		var recipe = find_matching_recipe(stack)
		if not recipe.is_empty():
			for s in stack:
				used.append(s)
			transform_stack(stack, recipe)
			return

func stack_is_stable(stack: Array[Item]) -> bool:
	for item in stack:
		if item.linear_velocity.length() > 15.0:
			return false
		#if abs(item.angular_velocity) > 1.0:
			#return false
	return true

func has_item_below(item: Item, all_items: Array[Item]) -> bool:
	return get_item_below(item, all_items) != null

func get_item_below(top_item: Item, all_items: Array[Item]) -> Item:
	var best_candidate: Item = null
	var best_distance := INF

	for other in all_items:
		if other == top_item:
			continue

		if is_item_on_top_of(top_item, other):
			var dist = top_item.global_position.distance_to(other.global_position)
			if dist < best_distance:
				best_distance = dist
				best_candidate = other

	return best_candidate

func get_item_above(lower_item: Item, all_items: Array[Item]) -> Item:
	var best_candidate: Item = null
	var best_distance := INF

	for other in all_items:
		if other == lower_item:
			continue

		if is_item_on_top_of(other, lower_item):
			var dist = lower_item.global_position.distance_to(other.global_position)
			if dist < best_distance:
				best_distance = dist
				best_candidate = other

	return best_candidate

func is_item_on_top_of(upper: Item, lower: Item) -> bool:
	var upper_pos = upper.global_position
	var lower_pos = lower.global_position

	var horizontal_diff = abs(upper_pos.x - lower_pos.x)
	var vertical_diff = lower_pos.y - upper_pos.y

	return vertical_diff > 0.0 and vertical_diff < 40.0 and horizontal_diff < 20.0

func build_stack_from_bottom(bottom: Item, all_items: Array[Item]) -> Array[Item]:
	var stack: Array[Item] = [bottom]
	var current = bottom

	while true:
		var above = get_item_above(current, all_items)
		if above == null:
			break
		stack.append(above)
		current = above

	return stack

func stack_to_ids(stack: Array[Item]) -> Array[String]:
	var ids: Array[String] = []
	for item in stack:
		ids.append(item.item_id)
	return ids

func find_matching_recipe(stack: Array[Item]) -> Dictionary:
	var stack_ids = stack_to_ids(stack)

	for recipe in recipes:
		if recipe["inputs"] == stack_ids:
			return recipe

	return {}

func transform_stack(stack: Array[Item], recipe: Dictionary) -> void:
	var spawn_position = Vector2.ZERO

	for item in stack:
		spawn_position += item.global_position

	spawn_position /= stack.size()
	
	spawn_poof(spawn_position)

	for item in stack:
		item.queue_free()

	var new_scene = ItemDatabase.get_scene(recipe["output"])
	var new_item = new_scene.instantiate()
	new_item.global_position = spawn_position
	get_tree().current_scene.add_child(new_item)


func spawn_poof(pos: Vector2) -> void:
	
	print("Ran the thing!")
	
	if poof_effect_scene == null:
		return

	var poof = poof_effect_scene.instantiate()
	poof.global_position = pos
	get_tree().current_scene.add_child(poof)
