extends Node2D

signal bubble_clicked

@onready var label: Label = $Label
@onready var click_area: Area2D = $Area2D

var order_key: String = ""

func _ready() -> void:
	click_area.input_event.connect(_on_area_input_event)

func set_text(new_text: String) -> void:
	if label:
		label.text = new_text

func set_order_key(new_key: String) -> void:
	order_key = new_key

func _on_area_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("bubble_clicked")
