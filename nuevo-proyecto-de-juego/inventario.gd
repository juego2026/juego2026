extends RefCounted

var _cantidades: Dictionary = {}


func cantidad(objeto: StringName) -> int:
	return _cantidades.get(objeto, 0)


func agregar(objeto: StringName, unidades: int) -> void:
	if unidades > 0:
		_cantidades[objeto] = cantidad(objeto) + unidades


func consumir(objeto: StringName, unidades: int) -> bool:
	var disponibles := cantidad(objeto)
	if unidades <= 0 or disponibles < unidades:
		return false

	_cantidades[objeto] = disponibles - unidades
	return true

func puede_fabricar(ingredientes: Dictionary) -> bool:
	for objeto in ingredientes:
		var unidades: int = ingredientes[objeto]
		if unidades <= 0 or cantidad(objeto) < unidades:
			return false

	return not ingredientes.is_empty()


func fabricar(ingredientes: Dictionary, producto: StringName, unidades: int) -> bool:
	if unidades <= 0 or not puede_fabricar(ingredientes):
		return false

	for objeto in ingredientes:
		consumir(objeto, ingredientes[objeto])

	agregar(producto, unidades)
	return true
