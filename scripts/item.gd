extends RigidBody2D
class_name Item

@export var item_id: String = ""
@export var tags: Array[String] = []

var is_being_held: bool = false
var grab_local_offset: Vector2 = Vector2.ZERO

@export var grill_result_id: String = ""
@export var grill_time: float = 0.0

@export var follow_force: float = 2000.0
@export var follow_damping: float = 35.0

func grab_at(global_point: Vector2) -> void:
	is_being_held = true
	grab_local_offset = to_local(global_point)
	sleeping = false

func release() -> void:
	is_being_held = false

func _physics_process(delta: float) -> void:
	if is_being_held:
		var mouse_pos = get_global_mouse_position()
		var grab_global_pos = to_global(grab_local_offset)

		var displacement = mouse_pos - grab_global_pos
		var force = displacement * follow_force - linear_velocity * follow_damping

		apply_force(force, grab_global_offset())

func grab_global_offset() -> Vector2:
	return to_global(grab_local_offset) - global_position

func can_be_grilled() -> bool:
	return grill_result_id != "" and grill_time > 0.0
