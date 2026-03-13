extends Area2D

@export var scene_to_spawn: PackedScene

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			spawn_scene()


func spawn_scene():
	var instance = scene_to_spawn.instantiate()
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
