extends Node2D
var skip = false
var simultaneous_scene = preload("res://scenes/intro_animada.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    $Overlay.visible = true
    var tween = get_tree().create_tween()
    await tween.tween_property($Overlay, "modulate:a", 0, 1)  # De 1 a 0 en 2 segundos
    $PressSpace.modulate.a = 0.0
    
    await get_tree().create_timer(4).timeout
    
    skip = true
    showPressSpacet()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("jump") and skip:
        skip = false
        tran_out()

func tran_out():
    var tween = get_tree().create_tween()
    tween.tween_property($Overlay, "modulate:a", 1, 1)  # De 1 a 0 en 2 segundos
    await get_tree().create_timer(2).timeout
    get_tree().change_scene_to_packed(simultaneous_scene)

func showPressSpacet():
    while skip:
        var tween = get_tree().create_tween()
        tween.tween_property($PressSpace, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)  # Disminuye rápido al inicio y luego más lento
        await get_tree().create_timer(0.7).timeout
        var tween2 = get_tree().create_tween()
        tween2.tween_property($PressSpace, "modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)  # Disminuye rápido al inicio y luego más lento
        await get_tree().create_timer(0.7).timeout
