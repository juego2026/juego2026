extends CharacterBody2D

@export var speed: float = 200.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	# Detectar movimiento en ocho direcciones
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)
	print("Movimiento detectado: ", direction)
	# Mover al personaje sin gravedad
	velocity = direction * speed
	move_and_slide()

	# Orientar el personaje a izquierda o derecha
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false

	# Reproducir animaciones si existen
	if direction == Vector2.ZERO:
		if animated_sprite_2d.sprite_frames.has_animation("Idle"):
			animated_sprite_2d.play("Idle")
	else:
		if animated_sprite_2d.sprite_frames.has_animation("Run"):
			animated_sprite_2d.play("Run")
		elif animated_sprite_2d.sprite_frames.has_animation("Walk"):
			animated_sprite_2d.play("Walk")
