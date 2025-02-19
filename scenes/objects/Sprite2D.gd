extends Sprite2D

@export var TEXTURE_VARIATIONS_ARRAY = [
    preload("res://assets/sprites/powerups/ave-del-terror/craneo.png"),
    preload("res://assets/sprites/powerups/ave-del-terror/hueso.png"),
    preload("res://assets/sprites/powerups/ave-del-terror/torso.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
    _variable_texture()

func _variable_texture():
    if TEXTURE_VARIATIONS_ARRAY.size() > 1:
        var texture_id: int = randi() % TEXTURE_VARIATIONS_ARRAY.size()
        var chosen_texture: Texture2D = TEXTURE_VARIATIONS_ARRAY[texture_id]
        texture = chosen_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
