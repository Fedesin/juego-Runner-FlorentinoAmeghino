extends Node2D

@onready var shader_material = $Overlay.material

var max_radius = 2.0  # El radio máximo
var duration = 1.6   # Tiempo total de la animación
var time_elapsed = 0.0

@onready var skull1 = $Skull1  # Asegúrate de que el path sea correcto
@onready var skull2 = $Skull2  # Asegúrate de que el path sea correcto

@onready var label1 = $Title1
@onready var label2 = $Title2

var skip = false
var gravity = 1000  # Aceleración de la caída
var bounce_factor = 0.1  # Cuánto rebota (0.5 = 50% de la velocidad anterior)
var bounces = 1  # Número de rebotes

var simultaneous_scene = preload("res://scenes/main.tscn")

func start_fall(label: RichTextLabel, delay: float):
    var end_y = label.position.y + 20
    var start_y = label.position.y - 200
    label.position.y = start_y 
    await get_tree().create_timer(delay).timeout
    var tween = create_tween()
    var fall_time = sqrt(2 * abs(end_y - start_y) / gravity)  # Fórmula de caída libre
    tween.tween_property(label, "position:y", end_y, fall_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    # Agregar rebotes
    for i in range(bounces):
        var bounce_height = (end_y - start_y) * bounce_factor / (i + 1)
        var bounce_time = sqrt(2 * bounce_height / gravity)
        end_y -= bounce_height
        tween.tween_property(label, "position:y", end_y, bounce_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
        tween.tween_property(label, "position:y", end_y + bounce_height, bounce_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.tween_property(label, "position:y", end_y, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func intro_start(delta):
        await get_tree().create_timer(0.2).timeout
        time_elapsed += delta
        var radius = time_elapsed / duration * max_radius
        shader_material.set_shader_parameter("radius", radius)

func _ready():
    $Subtitle.modulate.a = 0.0
    $Skull1.modulate.a = 0.0
    $Skull2.modulate.a = 0.0
    $PressSpace.modulate.a = 0.0
    skull1.play("default")  # Reemplaza "default" con el nombre de tu animación
    skull2.play("reverse")  # Reemplaza "default" con el nombre de tu animación
    start_fall(label1,0.5)
    start_fall(label2,1)
    await get_tree().create_timer(2).timeout
    showSubtitle()
    await get_tree().create_timer(1.6).timeout
    skip = true
    showPressSpacet()

func showSubtitle():
    var tween = create_tween()
    tween.tween_property($Skull2, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.tween_property($Subtitle, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    tween.tween_property($Skull1, "modulate:a", 1, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func showPressSpacet():
    while skip:
        var tween = get_tree().create_tween()
        tween.tween_property($PressSpace, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)  # Disminuye rápido al inicio y luego más lento
        await get_tree().create_timer(0.7).timeout
        var tween2 = get_tree().create_tween()
        tween2.tween_property($PressSpace, "modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)  # Disminuye rápido al inicio y luego más lento
        await get_tree().create_timer(0.7).timeout
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("jump") and skip:
        skip = false
        await get_tree().create_timer(0.3).timeout
        get_tree().change_scene_to_packed(simultaneous_scene)
        
    if time_elapsed < duration:
        intro_start(delta)
