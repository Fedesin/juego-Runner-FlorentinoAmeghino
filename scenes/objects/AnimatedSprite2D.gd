extends AnimatedSprite2D

@export var TEXTURE_VARIATIONS_ARRAY: Array[Texture2D] = [
    preload("res://assets/sprites/powerups/gliptodonte/craneo.png"),
    preload("res://assets/sprites/powerups/gliptodonte/hueso.png"),
    preload("res://assets/sprites/powerups/gliptodonte/torso.png")
]

const COLUMNS = 4  # Número de columnas en la spritesheet
const ROWS = 1     # Número de filas en la spritesheet

func _ready():
    # Obtener el nodo padre (Area2D)
    var coin_area = get_parent()
    var animal = coin_area.get_animal()
    # Crear las rutas de las texturas de manera dinámica
    var path1 = "res://assets/sprites/powerups/" + animal + "/craneo.png"
    var path2 = "res://assets/sprites/powerups/" + animal + "/hueso.png"
    var path3 = "res://assets/sprites/powerups/" + animal + "/torso.png"
    # load las texturas
    TEXTURE_VARIATIONS_ARRAY = [
        load(path1),
        load(path2),
        load(path3)
    ]
    _variable_texture()

func _variable_texture():
    if TEXTURE_VARIATIONS_ARRAY.is_empty():
        return

    var texture_id: int = randi() % TEXTURE_VARIATIONS_ARRAY.size()
    var chosen_texture: Texture2D = TEXTURE_VARIATIONS_ARRAY[texture_id]

    var frames = SpriteFrames.new()  # Crear un nuevo `SpriteFrames` para esta instancia
    frames.add_animation("default")

    # Calcular el tamaño de cada celda (frame)
    var frame_width = chosen_texture.get_width() / COLUMNS
    var frame_height = chosen_texture.get_height() / ROWS

    # Agregar cada fotograma a la animación
    for i in range(COLUMNS):
        var frame_texture = AtlasTexture.new()
        frame_texture.atlas = chosen_texture
        frame_texture.region = Rect2(i * frame_width, 0, frame_width, frame_height)

        frames.add_frame("default", frame_texture)  # Agregar frame correctamente

    set_sprite_frames(frames)  # Asignar los frames a la instancia actual

    # Iniciar la animación con los nuevos fotogramas
    play("default")
