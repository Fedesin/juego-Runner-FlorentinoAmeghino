extends Node2D

var game_running = true
var screen_size: Vector2i
var avanzar = false
var skip = false
var simultaneous_scene = preload("res://scenes/intro.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    $PressSpace.modulate.a = 0.0
    $Overlay.visible = true
    tran_in()
    screen_size = get_viewport().size
    var mega_time = 1.0
    var end_x = $Camera2D/Megaterio.position.x + 300
    var tween1 = create_tween()
    tween1.tween_property($Camera2D/Megaterio, "position:x", end_x, mega_time)
    await get_tree().create_timer(mega_time).timeout
    avanzar = true
    $Voice.play()
    $Music.play()
    await get_tree().create_timer(2).timeout
    skip = true
    showPressSpacet()
    await get_tree().create_timer(23).timeout
    tran_out()
    
    pass # Replace with function body.


func tran_in():
    var tween = get_tree().create_tween()
    await tween.tween_property($Overlay, "modulate:a", 0, 1)  # De 1 a 0 en 2 segundos
    
    
func tran_out():
    avanzar = false
    
    var end_x = $Camera2D/Megaterio.position.x + 1000
    var tween1 = create_tween()
    tween1.tween_property($Camera2D/Megaterio, "position:x", end_x, 3)
    
    var tween2 := create_tween()
    tween2.tween_property($Music, "volume_db", -80, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tween2.tween_property($Voice, "volume_db", -80, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    
    await get_tree().create_timer(1).timeout
    
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
        
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("jump") and skip:
        skip = false
        tran_out()

    var back_movement = 5
    if avanzar: 
        $Ground.position.x = $Ground.position.x - back_movement
        $Background/ParallaxLayer/Sprite2D.position.x = $Background/ParallaxLayer/Sprite2D.position.x - (back_movement / 2)

    if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.48:
        $Ground.position.x += screen_size.x
    if $Camera2D.position.x - $Background/ParallaxLayer/Sprite2D.position.x > screen_size.x * 1.5:
        $Background/ParallaxLayer/Sprite2D.position.x += screen_size.x

