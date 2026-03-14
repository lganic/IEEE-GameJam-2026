extends Area2D

@export var quant: int = 10
@export var scene_to_spawn: PackedScene
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var label: Label = $Label

var using_quant = true

func _input_event(viewport, event, shape_idx):
	
	if using_quant and quant == 0:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			spawn_scene()
			audio_player.play()
			quant = quant - 1

func _process(delta: float) -> void:
	# Update the label with the current quantity
	# If we are not using the quantity, set to blank
	
	if using_quant:
		label.text = str(quant)
	else:
		label.text = ""

func spawn_scene():
	var instance = scene_to_spawn.instantiate()
	instance.global_position = global_position
	get_tree().current_scene.add_child(instance)
