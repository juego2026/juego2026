extends CharacterBody2D

@export var speed: float = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: String = "down"
var is_attacking: bool = false

func _ready() -> void:
	print("--- INICIANDO DIAGNÓSTICO DE PERSONAJE ---")
	print("Velocidad inicial: ", speed)
	if speed <= 0:
		push_warning("¡ADVERTENCIA!: La variable 'speed' está en 0. Cambia el valor en el Inspector.")

func _physics_process(delta: float) -> void:
	if is_attacking:
		return

	if Input.is_action_pressed("attack"):
		perform_attack()
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = direction * speed
	
	move_and_slide()
	
	if direction != Vector2.ZERO:
		update_animation(direction)
	else:
		play_idle_animation()

func perform_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO
	match last_direction:
		"down": play_if_exists("attack_down")
		"up": play_if_exists("attack_up")
		"right": play_if_exists("attack_right")
		"left": play_if_exists("attack_left")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation.begins_with("attack_"):
		is_attacking = false

func update_animation(direction: Vector2) -> void:
	if animated_sprite_2d == null:
		return
	
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			last_direction = "right"
			play_if_exists("run_right")
		else:
			last_direction = "left"
			play_if_exists("run_left")
	else:
		if direction.y > 0:
			last_direction = "down"
			play_if_exists("run_down")
		else:
			last_direction = "up"
			play_if_exists("run_up")

func play_idle_animation() -> void:
	if animated_sprite_2d == null:
		return
		
	match last_direction:
		"down": play_if_exists("idle_down")
		"up": play_if_exists("idle_up")
		"right": play_if_exists("idle_right")
		"left": play_if_exists("idle_left")

func play_if_exists(anim_name: String) -> void:
	if animated_sprite_2d and animated_sprite_2d.sprite_frames and animated_sprite_2d.sprite_frames.has_animation(anim_name):
		animated_sprite_2d.play(anim_name)
