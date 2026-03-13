extends Control

@onready var label: RichTextLabel = $RichTextLabel
@onready var texture_rect: TextureRect = $TextureRect

var order_uid: int
var item_id: String

func setup(p_order_uid: int, p_item_id: String, display_text: String) -> void:
	order_uid = p_order_uid
	item_id = p_item_id
	
	label.bbcode_enabled = true
	label.text = "[font=res://fonts/retro-font.ttf][color=#000000][font_size=32]%s[/font_size][/color][/font]" % display_text

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
