
extends StaticBody2D

signal madera_obtenida(cantidad: int)

@export var resistencia_maxima: int = 3

var resistencia_actual: int

var jugador_cerca: Node2D = null

func _ready() -> void:
	resistencia_actual = resistencia_maxima


func recibir_golpe() -> void:
	if resistencia_actual <= 0:
		return
	
	resistencia_actual -= 1

	print("Golpe al árbol. Resistencia: ", resistencia_actual)

	if resistencia_actual <= 0:
		talar()

func talar() -> void:
	print("¡Árbol talado! Se ha obtenido 3 maderas.")
	madera_obtenida.emit(3)
	queue_free()
	


func _on_zona_tala_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		
		jugador_cerca = body
		
		print("¡Jugador cerca del árbol!")


func _on_zona_tala_body_exited(body: Node2D) -> void:
	if body == jugador_cerca:
		
		jugador_cerca = null
		
		print("El jugador se ha alejado del árbol.")
		
		# Esta función permite probar la tala sin usar todavía el personaje.
# Solo funcionará mientras tengamos esta prueba activada.
func _unhandled_key_input(event: InputEvent) -> void:
	# Si pulsamos la tecla T, simulamos un golpe al árbol.
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_T:
			recibir_golpe()
