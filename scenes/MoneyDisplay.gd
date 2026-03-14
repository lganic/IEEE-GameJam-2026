extends Label

var money = 0

func AddMoney(Amount:float):

	money = money + Amount

	text = "$" + str(money)

func _ready() -> void:
	AddMoney(0.00)
