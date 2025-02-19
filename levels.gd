extends Node

class_name Levels

# Preload el script de Level
var Level = preload("res://level.gd")

# Crear la lista de niveles
var levels = [
    Level.new("Frías I", "dientes-de-sable"),
    Level.new("Luján", "ave-del-terror"),
    Level.new("Paso del Cañón", "toxodonte"),
    Level.new("Archaval", "gliptodonte"),
    Level.new("Diaz", "megaterio"),
    Level.new("Frías II", "megaterio"),
    Level.new("Frías III", "ave-del-terror")
]

var current_level_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func get_level() -> Level:
    return levels[current_level_id]
    
func next() -> void:
    current_level_id = fmod(((current_level_id) + 1), levels.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
