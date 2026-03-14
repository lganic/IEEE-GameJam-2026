extends CharacterBody2D

@export var speed := 200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		sprite.flip_h = false;
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true;
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
