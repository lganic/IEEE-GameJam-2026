extends Node

var item_scenes: Dictionary = {
	"burger": preload("res://scenes/FoodItems/burger.tscn"),
	"cooked_patty": preload("res://scenes/FoodItems/patty.tscn"),
	"uncooked_patty": preload("res://scenes/FoodItems/uncooked.tscn"),
	"bun": preload("res://scenes/FoodItems/bun.tscn")
}

func get_scene(item_id: String):
	return item_scenes.get(item_id)
