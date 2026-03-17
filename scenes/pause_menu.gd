extends CanvasLayer

@onready var resume_button: Button = $VBoxContainer/ResumeButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("pause"):
		
		if get_tree().paused:
			resume_game()
		else:
			pause_game()

func pause_game() -> void:
	visible = true
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false
	visible = false

func _on_resume_pressed() -> void:
	resume_game()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
