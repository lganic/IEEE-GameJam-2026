extends Node

var item_scenes: Dictionary = {
	"burger": preload("res://scenes/FoodItems/burger.tscn"),
	"cooked_patty": preload("res://scenes/FoodItems/patty.tscn"),
	"uncooked_patty": preload("res://scenes/FoodItems/uncooked.tscn"),
	"bun": preload("res://scenes/FoodItems/bun.tscn"),
	"garbage": preload("res://scenes/FoodItems/garbage.tscn"),
	"biscuit": preload("res://scenes/FoodItems/biscuit.tscn"),
	"biscuit-cooked": preload("res://scenes/FoodItems/biscuit-cooked.tscn"),
	"bread_lower": preload("res://scenes/FoodItems/bread-lower.tscn"),
	"bread_upper": preload("res://scenes/FoodItems/bread-upper.tscn"),
	"bacon": preload("res://scenes/FoodItems/bacon.tscn"),
	"bacon-cooked": preload("res://scenes/FoodItems/bacon-cooked.tscn"),
	"jazza": preload("res://scenes/FoodItems/jazza.tscn"),
	"jazza-cooked": preload("res://scenes/FoodItems/jazza-cooked.tscn"),
	"zorp": preload("res://scenes/FoodItems/zorp.tscn"),
	"zorp-cooked": preload("res://scenes/FoodItems/zorp-cooked.tscn"),
	"snargle": preload("res://scenes/FoodItems/snargle.tscn"),
	"snargle-cooked": preload("res://scenes/FoodItems/snargle-cooked.tscn"),
	"biscuit-cooked-jazza": preload("res://scenes/FoodItems/biscuit-cooked-jazza.tscn"),
	"biscuit-cooked-zorp": preload("res://scenes/FoodItems/biscuit-cooked-zorp.tscn"),
	"biscuit-cooked-snargle": preload("res://scenes/FoodItems/biscuit-cooked-snargle.tscn"),
	"sand-jazza": preload("res://scenes/FoodItems/sand-jazza.tscn"),
	"sand-zorp": preload("res://scenes/FoodItems/sand-zorp.tscn"),
	"sand-snargle": preload("res://scenes/FoodItems/sand-snargle.tscn"),
	"sand-jazza-cooked": preload("res://scenes/FoodItems/sand-jazza-cooked.tscn"),
	"sand-zorp-cooked": preload("res://scenes/FoodItems/sand-zorp-cooked.tscn"),
	"sand-snargle-cooked": preload("res://scenes/FoodItems/sand-snargle-cooked.tscn"),
	"sand-bacon-jazza": preload("res://scenes/FoodItems/sand-bacon-jazza.tscn"),
	"sand-bacon-zorp": preload("res://scenes/FoodItems/sand-bacon-zorp.tscn"),
	"sand-bacon-snargle": preload("res://scenes/FoodItems/sand-bacon-snargle.tscn"),
	"sand-bacon-jazza-cooked": preload("res://scenes/FoodItems/sand-bacon-jazza-cooked.tscn"),
	"sand-bacon-zorp-cooked": preload("res://scenes/FoodItems/sand-bacon-zorp-cooked.tscn"),
	"sand-bacon-snargle-cooked": preload("res://scenes/FoodItems/sand-bacon-snargle-cooked.tscn"),
}

func get_scene(item_id: String):
	return item_scenes.get(item_id)
