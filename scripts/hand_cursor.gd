extends CanvasLayer

@onready var hand_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var zone_probe: Area2D = $ZoneProbe

var local_offset := Vector2(4, 8)

func _ready() -> void:
	_update_hand_animation()

func _process(_delta: float) -> void:
	var screen_mouse_pos = get_viewport().get_mouse_position()
	var world_mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()

	var target_position = screen_mouse_pos + local_offset

	print(world_mouse_pos)

	if world_mouse_pos.x < -231 or world_mouse_pos.x > 95 or world_mouse_pos.y < -127 or world_mouse_pos.y > 130:
		target_position = Vector2(-10000,0)

	# Hand sprite stays in screen/UI space
	hand_sprite.global_position = target_position

	# Probe goes into world space for physics overlap
	zone_probe.global_position = world_mouse_pos

	_update_hand_animation()

func _update_hand_animation() -> void:
	var in_zone := zone_probe.has_overlapping_areas() or zone_probe.has_overlapping_bodies()
	var pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	var target_anim := "idle"

	if in_zone:
		if pressed:
			target_anim = "zone_press"
			local_offset = Vector2(0, 0)
		else:
			target_anim = "zone_idle"
			local_offset = Vector2(7, 13)
	else:
		target_anim = "idle"
		local_offset = Vector2(11, 11)

	if hand_sprite.animation != target_anim:
		hand_sprite.play(target_anim)
