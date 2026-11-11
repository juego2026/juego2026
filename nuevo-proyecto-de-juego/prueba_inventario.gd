extends Control

const MADERA: StringName = &"madera"
const TABLON: StringName = &"tablon"
const HACHA: StringName = &"hacha"
const ESPADA: StringName = &"espada"
const PICO: StringName = &"pico"
const RECETAS = [
	{producto = TABLON, nombre = "tablón", ingredientes = {MADERA: 2}},
	{producto = HACHA, nombre = "hacha de madera", ingredientes = {TABLON: 1, MADERA: 3}},
	{producto = ESPADA, nombre = "espada de madera", ingredientes = {TABLON: 1, MADERA: 2}},
	{producto = PICO, nombre = "pico de madera", ingredientes = {TABLON: 1, MADERA: 3}},
]
const NOMBRES = {
	MADERA: ["madera", "madera"],
	TABLON: ["tablón", "tablones"],
	HACHA: ["hacha de madera", "hachas de madera"],
	ESPADA: ["espada de madera", "espadas de madera"],
	PICO: ["pico de madera", "picos de madera"],
}


const ALCANCE_ARBOL := 40.0

var _botones: Array[Button] = []
var _contadores: Dictionary = {}

@onready var inventario = $Centro/Contenido/Zona/Jugador/InventarioJugador.inventario
@onready var panel: VBoxContainer = $Centro/Contenido/Panel
@onready var aviso_panel: Label = $Centro/Contenido/AvisoPanel
@onready var cantidades: VBoxContainer = $Centro/Contenido/Panel/Cantidades
@onready var recetas: VBoxContainer = $Centro/Contenido/Panel/Recetas


@onready var zona: ColorRect = $Centro/Contenido/Zona
@onready var jugador: CharacterBody2D = $Centro/Contenido/Zona/Jugador
@onready var arbol: ColorRect = $Centro/Contenido/Zona/Arbol
@onready var ayuda: Label = $Centro/Contenido/Ayuda


func _ready() -> void:
	for objeto in NOMBRES:
		var contador := Label.new()
		contador.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cantidades.add_child(contador)
		_contadores[objeto] = contador

	for receta in RECETAS:
		var boton := Button.new()
		var coste := PackedStringArray()
		for objeto in receta.ingredientes:
			var unidades: int = receta.ingredientes[objeto]
			var nombre: String = NOMBRES[objeto][0 if unidades == 1 else 1]
			var formato := "%d de %s" if objeto == MADERA else "%d %s"
			coste.append(formato % [unidades, nombre])

		boton.text = "Fabricar %s (%s)" % [receta.nombre, " + ".join(coste)]
		boton.pressed.connect(_fabricar.bind(receta))
		recetas.add_child(boton)
		_botones.append(boton)

	_actualizar_interfaz()


func _process(_delta: float) -> void:
	jugador.position = jugador.position.clamp(Vector2(15, 20), zona.size - Vector2(15, 16))
	ayuda.text = "Pulsa E para recoger madera" if _cerca_del_arbol() else "Acércate al árbol con WASD"


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_I:
		panel.visible = not panel.visible
		aviso_panel.text = "I · Cerrar inventario" if panel.visible else "I · Abrir inventario"
		get_viewport().set_input_as_handled()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_E:
		if _cerca_del_arbol():
			inventario.agregar(MADERA, 1)
			_actualizar_interfaz()


func _cerca_del_arbol() -> bool:
	return jugador.position.distance_to(arbol.get_rect().get_center()) <= ALCANCE_ARBOL


func _fabricar(receta: Dictionary) -> void:
	if inventario.fabricar(receta.ingredientes, receta.producto, 1):
		_actualizar_interfaz()


func _actualizar_interfaz() -> void:
	for objeto in _contadores:
		var nombre: String = NOMBRES[objeto][1]
		var nombre_visible := nombre.left(1).to_upper() + nombre.substr(1)
		_contadores[objeto].text = "%s: %d" % [nombre_visible, inventario.cantidad(objeto)]

	for indice in RECETAS.size():
		_botones[indice].disabled = not inventario.puede_fabricar(RECETAS[indice].ingredientes)
