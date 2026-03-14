extends Node2D

@onready var customer_sprite: AnimatedSprite2D = $Customer
@onready var customer_animation: AnimationPlayer = $"Customer Animation"

@onready var meep_player: AudioStreamPlayer2D = $"MeepPlayer"
@onready var paper_player: AudioStreamPlayer2D = $"PaperPlayer"

@export var speech_bubble_scene: PackedScene
@export var speech_bubble_spawn_offset: Vector2 = Vector2(-280, 50)

@export var receipt_manager_path: NodePath
@onready var receipt_manager = get_node(receipt_manager_path)

var current_customer: int = 0
var current_order_key: String = ""
var current_bubble: Node = null

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

#Some customer names: Glorp, GortandSon, Karen.
var order_text := {
	"biscuit-cooked-jazza": "BISCUIT\nJAZZA JAM",
	"biscuit-cooked-zorp": "BISCUIT\nZORP JAM",
	"biscuit-cooked-snargle": "BISCUIT\nSNARGLE JAM",
	"sand-jazza": "JAZZA JAM\nSANDWICH",
	"sand-zorp": "ZORP JAM\nSANDWICH",
	"sand-snargle": "SNARGLE JAM\nSANDWICH",
	"sand-jazza-cooked": "JAZZA JAM\nCOOKED\nSANDWICH",
	"sand-zorp-cooked": "ZORP JAM\nCOOKED\nSANDWICH",
	"sand-snargle-cooked": "SNARGLE JAM\nCOOKED\nSANDWICH",
	"sand-bacon-jazza": "BACON\nJAZZA JAM\nSANDWICH",
	"sand-bacon-zorp": "BACON\nZORP JAM\nSANDWICH",
	"sand-bacon-snargle": "BACON\nSNARGLE JAM\nSANDWICH",
	"sand-bacon-jazza-cooked": "BACON\nJAZZA JAM\nCOOKED\nSANDWICH",
	"sand-bacon-zorp-cooked": "BACON\nZORP JAM\nCOOKED\nSANDWICH",
	"sand-bacon-snargle-cooked": "BACON\nSNARGLE JAM\nCOOKED\nSANDWICH",
}

#Call this when you want customer to walk in (Give name of customer!
#TIP: Click customer in scene tree and look at inspector, list of names is under "Animation".)
func spawn_customer(name: String) -> void:
	customer_sprite.visible = true
	customer_sprite.animation = name
	customer_animation.play("Customer Enter")
	
	customer_animation.animation_finished.connect(_spawn_order_bubble)

func _add_random_customer(meh: StringName) -> void:
	
	customer_animation.animation_finished.disconnect(_add_random_customer)
	
	var items = ["Glorp", "GortandSon", "Karen"]

	var random_item = items[randi() % items.size()]
	
	spawn_customer(random_item)


#Call this when you want customer to walk away
func remove_customer() -> void:
	#customer_sprite.visible = false
	customer_animation.play("Customer Leave")
	customer_animation.animation_finished.connect(_add_random_customer)

	if current_bubble and is_instance_valid(current_bubble):
		current_bubble.queue_free()
		current_bubble = null

func _spawn_order_bubble(meh: StringName) -> void:
	
	meep_player.pitch_scale = rng.randf_range(.75, 1.25)
	meep_player.play()
	
	customer_animation.animation_finished.disconnect(_spawn_order_bubble) # Just to be safe
	
	# Remove old bubble if one exists
	if current_bubble and is_instance_valid(current_bubble):
		current_bubble.queue_free()
		current_bubble = null

	# Pick one random order key
	var keys := order_text.keys()
	if keys.is_empty():
		push_warning("No order_text entries found.")
		return

	current_order_key = keys[randi() % keys.size()]
	var bubble_text: String = order_text[current_order_key]

	# Spawn bubble scene
	if speech_bubble_scene == null:
		push_warning("speech_bubble_scene is not assigned.")
		return

	current_bubble = speech_bubble_scene.instantiate()
	add_child(current_bubble)

	# Position it above the customer
	if current_bubble is Node2D:
		current_bubble.position = customer_sprite.position + speech_bubble_spawn_offset

	# Set bubble text
	if current_bubble.has_method("set_text"):
		current_bubble.set_text(bubble_text)

	# Optional: if you want bubble to know the order key too
	if current_bubble.has_method("set_order_key"):
		current_bubble.set_order_key(current_order_key)

	# Hook up click signal
	if current_bubble.has_signal("bubble_clicked"):
		current_bubble.bubble_clicked.connect(_on_bubble_clicked)

func _on_bubble_clicked() -> void:
	if current_bubble and is_instance_valid(current_bubble):
		current_bubble.queue_free()
		current_bubble = null
	
	paper_player.play()

	remove_customer()
	
	receipt_manager.add_order(current_order_key)

func _on_intro_cinematic_anim_animation_finished(anim_name: StringName) -> void:
	spawn_customer("Glorp")
