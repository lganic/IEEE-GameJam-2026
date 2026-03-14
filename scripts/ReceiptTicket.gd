extends Control

signal expired(order_uid: int)

@onready var label: RichTextLabel = $RichTextLabel
@onready var texture_rect: TextureRect = $TextureRect
@onready var lifetime_pie: TextureProgressBar = $LifetimePie

var order_uid: int
var item_id: String

var total_lifetime: float = 10.0
var remaining_lifetime: float = 10.0
var is_expiring := false

func setup(p_order_uid: int, p_item_id: String, display_text: String, lifetime: float) -> void:
	order_uid = p_order_uid
	item_id = p_item_id
	total_lifetime = lifetime
	remaining_lifetime = lifetime
	
	label.bbcode_enabled = true
	label.text = "[font=res://fonts/retro-font.ttf][color=#000000][font_size=32]%s[/font_size][/color][/font]" % display_text
	
	_update_lifetime_ui()

func _process(delta: float) -> void:
	if is_expiring:
		return
	
	remaining_lifetime -= delta
	remaining_lifetime = max(remaining_lifetime, 0.0)
	_update_lifetime_ui()
	
	if remaining_lifetime <= 0.0:
		is_expiring = true
		expired.emit(order_uid)

func _update_lifetime_ui() -> void:
	if lifetime_pie:
		lifetime_pie.value = remaining_lifetime / total_lifetime

func move_to(target_pos: Vector2, duration: float = 0.25) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", target_pos, duration)

func play_complete_and_disappear() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.2)
	tween.finished.connect(queue_free)

func play_expire_and_disappear() -> void:
	is_expiring = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.25)
	tween.tween_property(self, "rotation", deg_to_rad(10), 0.25)
	tween.finished.connect(queue_free)
