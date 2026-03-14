extends Node2D
@onready var CustomerSprite:AnimatedSprite2D = $Customer
@onready var CustomerAnimation:AnimationPlayer = $"Customer Animation"
var CurrentCustomer:int
#Some customer names: Glorp, GortandSon, Karen.


#Call this when you want customer to walk in (Give name of customer!
#TIP: Click customer in scene tree and look at inspector, list of names is under "Animation".)
func SpawnCustomer(Name:String):
	CustomerSprite.visible = true
	CustomerSprite.animation = Name
	
	CustomerAnimation.play("Customer Enter")

#Call this when you want customer to walk away
func RemoveCustomer():
	CustomerSprite.visible = false
	CustomerAnimation.play("Customer Leave")




func _on_intro_cinematic_anim_animation_finished(anim_name: StringName) -> void:
	SpawnCustomer("Glorp")
