extends Control

@export var receipt_scene: PackedScene
@export var start_pos := Vector2(60, 60)   # rightmost receipt position
@export var spacing := 45.0
@export var move_time := 0.25

var next_order_uid := 0
var active_orders: Array = []
var receipt_nodes: Array = []

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

func add_order(item_id: String) -> void:
	var order = {
		"order_uid": next_order_uid,
		"item_id": item_id
	}
	next_order_uid += 1
	active_orders.append(order)

	var receipt = receipt_scene.instantiate()
	add_child(receipt)

	receipt.setup(order["order_uid"], item_id, order_text.get(item_id, item_id), 120) # 120 is lifetime
	
	receipt.expired.connect(_on_receipt_expired)
	
	receipt_nodes.append(receipt)

	_reflow_receipts()
	
func _reflow_receipts() -> void:
	for i in range(receipt_nodes.size()):
		var receipt = receipt_nodes[i]
		var target = start_pos - Vector2(spacing * i, 0)
		receipt.move_to(target, move_time)

func try_fulfill(item_id: String) -> bool:
	for i in range(active_orders.size()):
		if active_orders[i]["item_id"] == item_id:
			_remove_order_at(i)
			return true
	
	return false
			
func _remove_order_at(index: int, expired: bool = false) -> void:
	active_orders.remove_at(index)

	var receipt = receipt_nodes[index]
	receipt_nodes.remove_at(index)

	if expired:
		receipt.play_expire_and_disappear()
	else:
		receipt.play_complete_and_disappear()

	_reflow_receipts()

@export var possible_orders: Array[String] = ["sand-bacon-jazza", "sand-bacon-jazza-cooked"]
@export var max_orders := 5

func spawn_random_order() -> void:
	if active_orders.size() >= max_orders:
		return

	var item_id = possible_orders.pick_random()
	
	print("Adding " + item_id)
	
	add_order(item_id)

func _on_receipt_expired(order_uid: int) -> void:
	for i in range(active_orders.size()):
		if active_orders[i]["order_uid"] == order_uid:
			_remove_order_at(i, true)
			return
