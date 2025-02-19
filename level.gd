extends RefCounted  # Cambiado de Node a RefCounted para que sea una clase no basada en nodos

class_name Level

var animal: String
var title: String

# Constructor (_init en GDScript)
func _init(level_name: String, animal_name: String):
    title = level_name
    animal = animal_name

# Métodos para obtener los valores
func get_title() -> String:
    return title

func get_animal() -> String:
    return animal
