extends Node

class_name Levels

# Preload el script de Level
var Level = preload("res://scripts/level.gd")
const Animal = preload("res://scripts/animal.gd")

# Crear animales == crearAnimal( NOMBRE, SPRITE-IN-GAME, FOTO-FOSIL, FOTO-ANIMAL)
var dientesDeSable = crearAnimal("Tigre Diente de Sable", "res://assets/sprites/powerups/dientes-de-sable/", "res://assets/sprites/animal-pics/dientes-de-sable-fosil.jpeg", "res://assets/sprites/animal-pics/dientes-de-sable-animal.jpeg")
var aveDelTerror = crearAnimal("Ave del Terror", "res://assets/sprites/powerups/ave-del-terror/", "res://assets/sprites/animal-pics/ave-del-terror-fosil.jpg", "res://assets/sprites/animal-pics/ave-del-terror-animal.jpeg")
var toxodonte = crearAnimal("Toxodonte", "res://assets/sprites/powerups/toxodonte/", "res://assets/sprites/animal-pics/toxodonte-fosil.jpeg", "res://assets/sprites/animal-pics/toxodonte-animal.jpeg")
var gliptodonte = crearAnimal("Gliptodonte", "res://assets/sprites/powerups/gliptodonte/", "res://assets/sprites/animal-pics/gliptodonte-fosil.jpeg", "res://assets/sprites/animal-pics/gliptodonte-animal.jpeg")
var megaterio = crearAnimal("Megaterio", "res://assets/sprites/powerups/megaterio/", "res://assets/sprites/animal-pics/megaterio-fosil.jpeg", "res://assets/sprites/animal-pics/megaterio-animal.jpeg")

# Crear la lista de niveles    dientesDeSable
var levels = [
    Level.new("Frías I", dientesDeSable, 1, "dia"),
    Level.new("Luján", aveDelTerror,1, "tarde"),
    Level.new("Paso del Cañón", toxodonte, 1, "noche"),
    Level.new("Archaval", gliptodonte, 1,"dia"),
    Level.new("Diaz", megaterio, 1, "tarde"),
    Level.new("Frías II", megaterio, 1, "noche"),
    Level.new("Frías III", aveDelTerror, 1, "dia")
]

var current_level_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func crearAnimal(_name: String = "", _pathBonesImages: String = "", _pathFosilPhot: String = "", _pathAnimalPhoto: String = "") -> Animal:
    var animalAux = Animal.new()
    animalAux.name = _name
    animalAux.pathBonesImages = _pathBonesImages
    animalAux.pathFosilPhoto = _pathFosilPhot
    animalAux.pathAnimalPhoto = _pathAnimalPhoto
    return animalAux

func get_level() -> Level:
    return levels[current_level_id]
    
func next() -> void:
    current_level_id = fmod(((current_level_id) + 1), levels.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
