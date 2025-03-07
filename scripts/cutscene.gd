extends CanvasLayer

signal time_expired

@onready var mater: ShaderMaterial = $Photo.material  # Asegúrate de que el Sprite tenga el ShaderMaterial
@onready var photo: Sprite2D = $Photo

var skip = false

# Called when the node enters the scene tree for the first time.
func _ready():
    $Label2.modulate.a = 0.0
    pass
    
func playCutscene(animal: Animal):
    $Overlay.modulate.a = 1.0  # Totalmente opaco
    mater.set_shader_parameter("amount", 100.0)
    var animalNameText = "[center][shake rate=15.0 level=5 connected=1]" + animal.name + "[/shake][/center]"
    $AnimalName.text = animalNameText
    
    print(animal.name)
    var photo_texture = load(animal.pathFosilPhoto)
    $Photo.texture = photo_texture
    transicion()
    florencioAnimation()
    await get_tree().create_timer(0.4).timeout
    animalAnimation(animal)
    await get_tree().create_timer(6.4).timeout
    
func pressSpaceAnimation():
    while skip:
        var tween = get_tree().create_tween()
        tween.tween_property($Label2, "modulate:a", 1.0, 0.8)  # Cambia `amount` a 0 en 2 segundos
        tween.set_trans(Tween.TRANS_CUBIC)  # Hace la animación más suave
        tween.set_ease(Tween.EASE_IN)  # Disminuye rápido al inicio y luego más lento
        await get_tree().create_timer(0.8).timeout
        var tween2 = get_tree().create_tween()
        tween2.tween_property($Label2, "modulate:a", 0.0, 0.8)  # Cambia `amount` a 0 en 2 segundos
        tween2.set_trans(Tween.TRANS_CUBIC)  # Hace la animación más suave
        tween2.set_ease(Tween.EASE_OUT)  # Disminuye rápido al inicio y luego más lento
        await get_tree().create_timer(0.8).timeout

func animalAnimation(animal: Animal):
    var tween = get_tree().create_tween()
    tween.tween_property(mater, "shader_parameter/amount", 0.0, 1.4)  # Cambia `amount` a 0 en 2 segundos
    tween.set_trans(Tween.TRANS_CUBIC)  # Hace la animación más suave
    tween.set_ease(Tween.EASE_OUT)  # Disminuye rápido al inicio y luego más lento
    
    await get_tree().create_timer(4).timeout
    
    var tween2 = get_tree().create_tween()
    tween2.tween_property(mater, "shader_parameter/amount", 300, 1.0)  # Cambia `amount` a 0 en 2 segundos
    tween2.set_trans(Tween.TRANS_CUBIC)  # Hace la animación más suave
    tween2.set_ease(Tween.EASE_IN)  # Disminuye rápido al inicio y luego más lento
    
    await get_tree().create_timer(1.0).timeout
    
    var photo_texture = load(animal.pathAnimalPhoto)
    $Photo.texture = photo_texture
    skip = true
    pressSpaceAnimation()
    
    var tween3 = get_tree().create_tween()
    tween3.tween_property(mater, "shader_parameter/amount", 0.0, 1.4)  # Cambia `amount` a 0 en 2 segundos
    tween3.set_trans(Tween.TRANS_CUBIC)  # Hace la animación más suave
    tween3.set_ease(Tween.EASE_OUT)  # Disminuye rápido al inicio y luego más lento
    

func florencioAnimation():
    var tween = get_tree().create_tween()
    var sprite: Sprite2D = get_node("Florencio")
    var shake = 5
    var shake_duration = 0.3
    var shake_count = 20
    for i in range(shake_count):
        var shake_offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
        tween.tween_property(sprite, "position", sprite.position + shake_offset, shake_duration)
    tween.play()  # No es necesario en Godot 4, los tweens comienzan automáticamente

func transicion():
    var tween = get_tree().create_tween()
    await tween.tween_property($Overlay, "modulate:a", 0, 1)  # De 1 a 0 en 2 segundos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("jump") and skip:
        skip = false
        var main = get_parent()
        self.visible = false
        main.passLevel()
        time_expired.emit()
