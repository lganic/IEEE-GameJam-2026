extends Area2D

@export var order_manager_path: NodePath
@onready var order_manager = get_node(order_manager_path)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.has_method("get_item_id") and body.get("item_id") == null:
		return

	var id = body.get("item_id")
	var matched = order_manager.try_fulfill(id)

	if matched:
		body.queue_free()
	else:
		# optional: reject animation / sound
		pass
