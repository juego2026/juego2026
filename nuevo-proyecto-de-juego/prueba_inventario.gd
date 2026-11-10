extends Control

const COSTE_TABLON: int = 2

var madera: int = 0
var tablones: int = 0

@onready var contador: Label = $Centro/Contenido/Contador
@onready var contador_tablones: Label = $Centro/Contenido/Tablones
@onready var boton_fabricar: Button = $Centro/Contenido/FabricarTablon


func _ready() -> void:
	actualizar_interfaz()


func _on_anadir_madera_pressed() -> void:
	madera += 1
	actualizar_interfaz()


func _on_fabricar_tablon_pressed() -> void:
	if madera < COSTE_TABLON:
		return

	madera -= COSTE_TABLON
	tablones += 1
	actualizar_interfaz()


func actualizar_interfaz() -> void:
	contador.text = "Madera: %d" % madera
	contador_tablones.text = "Tablones: %d" % tablones
	boton_fabricar.disabled = madera < COSTE_TABLON
