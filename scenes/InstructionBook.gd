extends Control

@onready var book_panel: Control = $BookPanel
@onready var page_texture: TextureRect = $BookPanel/PageTexture
@onready var next_button: Button = $BookPanel/NextButton
@onready var prev_button: Button = $BookPanel/PrevButton
@onready var toggle_button: Button = $ToggleBookButton

var pages: Array[Texture2D] = [
	preload("res://assets/book pages/instructs_ins1.png"),
	preload("res://assets/book pages/instructs_ins2.png"),
	preload("res://assets/book pages/instructs_ins3.png"),
	preload("res://assets/book pages/instructs_ins4.png"),
	preload("res://assets/book pages/instructs_ins5.png"),
	preload("res://assets/book pages/instructs_ins6.png"),
]

var current_page: int = 0

func _ready() -> void:
	toggle_button.pressed.connect(_on_toggle_book)
	next_button.pressed.connect(_on_next_page)
	prev_button.pressed.connect(_on_prev_page)

	book_panel.visible = false
	_update_page()

func _on_toggle_book() -> void:
	book_panel.visible = !book_panel.visible

func _on_next_page() -> void:
	if current_page < pages.size() - 1:
		current_page += 1
		_update_page()

func _on_prev_page() -> void:
	if current_page > 0:
		current_page -= 1
		_update_page()

func _update_page() -> void:
	if pages.size() == 0:
		page_texture.texture = null
		return

	page_texture.texture = pages[current_page]

	prev_button.disabled = current_page == 0
	next_button.disabled = current_page == pages.size() - 1
