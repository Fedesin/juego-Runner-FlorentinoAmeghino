extends Node

class_name Levels

# Preload el script de Level
var Level = preload("res://level.gd")
const Animal = preload("res://animal.gd")

# Crear animales
var dientesDeSable = crearAnimal("Tigre Diente de Sable", "res://assets/sprites/powerups/dientes-de-sable/", "", "")
var aveDelTerror = crearAnimal("Ave del Terror", "res://assets/sprites/powerups/ave-del-terror/", "", "")
var toxodonte = crearAnimal("Toxodonte", "res://assets/sprites/powerups/toxodonte/", "", "")
var gliptodonte = crearAnimal("Gliptodonte", "res://assets/sprites/powerups/gliptodonte/", "", "")
var megaterio = crearAnimal("Megaterio", "res://assets/sprites/powerups/megaterio/", "", "")

# Crear la lista de niveles
var levels = [
    Level.new("Frías I", dientesDeSable),
    Level.new("Luján", aveDelTerror),
    Level.new("Paso del Cañón", toxodonte),
    Level.new("Archaval", gliptodonte),
    Level.new("Diaz", megaterio),
    Level.new("Frías II", megaterio),
    Level.new("Frías III", aveDelTerror)
]

var current_level_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func crearAnimal(_name: String = "", _pathBonesImages: String = "", _pathInfoImages: String = "", _info: String = "") -> Animal:
    var animalAux = Animal.new()
    animalAux.pathBonesImages = _pathBonesImages
    animalAux.pathInfoImages = _pathInfoImages
    animalAux.info = _info
    return animalAux

func get_level() -> Level:
    return levels[current_level_id]
    
func next() -> void:
    current_level_id = fmod(((current_level_id) + 1), levels.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
