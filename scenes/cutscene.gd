extends CanvasLayer

signal time_expired

@onready var mater: ShaderMaterial = $Photo2.material  # Asegúrate de que el Sprite tenga el ShaderMaterial
@onready var photo: Sprite2D = $Photo2
const Animal = preload("res://scripts/animal.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    
func playCutscene(animal: Animal):
    #await get_tree().create_timer(0.5).timeout
    animalAnimation(animal)
    florencioAnimation()

func animalAnimation(animal: Animal):
    var tween = get_tree().create_tween()
    tween.tween_property(mater, "shader_parameter/amount", 0.0, 2.0)  # Cambia `amount` a 0 en 2 segundos
    tween.set_trans(Tween.TRANS_CUBIC)  # Hace la animación más suave
    tween.set_ease(Tween.EASE_OUT)  # Disminuye rápido al inicio y luego más lento
    

func florencioAnimation():
    var tween = get_tree().create_tween()
    var sprite: Sprite2D = get_node("Florencio2")
    var shake = 5
    var shake_duration = 0.3
    var shake_count = 20
    for i in range(shake_count):
        var shake_offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
        tween.tween_property(sprite, "position", sprite.position + shake_offset, shake_duration)
    tween.play()  # No es necesario en Godot 4, los tweens comienzan automáticamente

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("jump"):
        var main = get_parent()
        #PASAR ESCENA
        time_expired.emit()
