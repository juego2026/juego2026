
extends CharacterBody2D



@export var speed = 200
@export var jump = -300



var gravity = 980
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
	
		velocity += get_gravity() * delta

	# mmaneja salto.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump

	# Devuelve la direcccion del jugador ---> -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Invertir Sprite
	if direction <0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
	
	# Agrega movimiento
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
