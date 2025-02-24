extends RefCounted  # Cambiado de Node a RefCounted para que sea una clase no basada en nodos

class_name Level

const Animal = preload("res://animal.gd")

var animal: Animal
var title: String

# Constructor (_init en GDScript)
func _init(level_name: String, _animal: Animal):
    title = level_name
    animal = _animal

# Métodos para obtener los valores
func get_title() -> String:
    return title

func get_animal() -> Animal:
    return animal
