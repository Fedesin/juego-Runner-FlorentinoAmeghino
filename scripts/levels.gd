extends Node

class_name Levels

# Preload el script de Level
var Level = preload("res://scripts/level.gd")
const Animal = preload("res://scripts/animal.gd")

# Crear animales == crearAnimal( NOMBRE, SPRITE-IN-GAME, FOTO-FOSIL, FOTO-ANIMAL)
var dientesDeSable = crearAnimal("Tigre Diente de Sable", "res://assets/sprites/powerups/dientes-de-sable/", "res://assets/sprites/animals/oldAnimals/dientes-de-sable-fosil.png", "res://assets/sprites/animals/oldAnimals/dientes-de-sable-animal.png")
var aveDelTerror = crearAnimal("Ave del Terror", "res://assets/sprites/powerups/ave-del-terror/", "res://assets/sprites/animals/oldAnimals/ave-del-terror-fosil.png", "res://assets/sprites/animals/oldAnimals/ave-del-terror-animal.png")
var toxodonte = crearAnimal("Toxodonte", "res://assets/sprites/powerups/toxodonte/", "res://assets/sprites/animals/oldAnimals/toxodonte-fosil.png", "res://assets/sprites/animals/oldAnimals/toxodonte-animal.png")
var gliptodonte = crearAnimal("Gliptodonte", "res://assets/sprites/powerups/gliptodonte/", "res://assets/sprites/animals/oldAnimals/gliptodonte-fosil.png", "res://assets/sprites/animals/oldAnimals/gliptodonte-animal.png")
var megaterio = crearAnimal("Megaterio", "res://assets/sprites/powerups/megaterio/", "res://assets/sprites/animals/oldAnimals/megaterio-fosil.png", "res://assets/sprites/animals/oldAnimals/megaterio-animal.png")

# Crear la lista de niveles    dientesDeSable
var levels = [
    Level.new("Frías I", dientesDeSable, 3, "dia", false),
    Level.new("Luján", aveDelTerror, 3, "tarde", false),
    Level.new("Paso del Cañón", toxodonte, 3, "noche", false),
    Level.new("Archaval", gliptodonte, 4,"dia", false),
    Level.new("Diaz", megaterio, 4, "tarde", false),
    Level.new("Frías II", megaterio, 5, "noche", true),
    Level.new("Frías III", aveDelTerror, 5, "dia", false),
    Level.new("<FIN>", null, 0, "", false)
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
