extends RefCounted  # Cambiado de Node a RefCounted para que sea una clase no basada en nodos

class_name Level

const Animal = preload("res://scripts/animal.gd")

var animal: Animal
var title: String
var scene: String
var maxScore: int

# Constructor (_init en GDScript)
func _init(level_name: String, _animal: Animal, _maxScore:int, _scene: String):
    title = level_name
    animal = _animal
    maxScore = _maxScore
    scene = _scene

# Métodos para obtener los valores
func get_title() -> String:
    return title

func get_animal() -> Animal:
    return animal
    
func getMaxScore() -> int:
    return maxScore

func get_scene() -> String:
    return scene
