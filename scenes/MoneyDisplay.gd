extends Label
func AddMoney(Amount:float):
	text = str(Amount)


func _ready() -> void:
	AddMoney(10.00)
