extends Node2D

# Rotation speed in degrees per second (very slow)
@export var rotation_speed := -.05

func _process(delta):
	rotation += deg_to_rad(rotation_speed) * delta
