extends Node2D

var held_item: Item = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			try_pickup()
		else:
			drop_item()

func try_pickup() -> void:
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()

	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var results = space_state.intersect_point(query)

	if results.is_empty():
		return

	for result in results:
		var collider = result.collider
		if collider is Item:
			held_item = collider
			held_item.grab_at(mouse_pos)
			break

func drop_item() -> void:
	if held_item:
		held_item.release()
		held_item = null
