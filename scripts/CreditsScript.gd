extends Node2D

var my_shader = preload("res://scenes/card_shadow.gdshader")

func _ready():
    await get_tree().create_timer(0.2).timeout
    transicion()
    await get_tree().create_timer(1.0).timeout

    for i in range(1, 6):
        var photo_a = get_node("Photos/PhotoA" + str(i))
        var photo_b = get_node("Photos/PhotoB" + str(i))
        add_shadow_clone(photo_a, my_shader)
        add_shadow_clone(photo_b, my_shader)
        
        movePhoto(photo_a, true)
        await get_tree().create_timer(0.8).timeout
        movePhoto(photo_b, false)
        await get_tree().create_timer(2.5).timeout
    
    await get_tree().create_timer(0.5).timeout
    moveSign($CartelFlorentino)
    
func movePhoto(photo, left):
    var tween = create_tween()
    var target_pos
    var aux1 = randi_range(-15, 15)
    var aux2 = randi_range(-15, 15)
    var aux3 = randi_range(-10, 10)
    if left:
        target_pos = Vector2(aux1 + 300, aux2 + 300)
        photo.position = target_pos + Vector2(-300, 200)
        photo.rotation = deg_to_rad(-20 + aux3)
    else:
        target_pos = Vector2(aux1 + 800, aux2 + 300)
        photo.position = target_pos + Vector2(1000, 200)
        photo.rotation = deg_to_rad(20 + aux3)

    # Crear dos animaciones en paralelo
    tween.tween_property(photo, "position", target_pos, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func moveSign(sign: Node2D):
    var tween = create_tween()
    tween.set_parallel()  # ejecutar animaciones al mismo tiempo

    var target_pos = sign.position + Vector2(0, 600)
    var target_scale = sign.scale
    sign.scale = sign.scale * 1.5

    tween.tween_property(sign, "position", target_pos, 1.0)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

    tween.tween_property(sign, "scale", target_scale, 1.0)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func transicion():
    var tween = get_tree().create_tween()
    await tween.tween_property($Overlay, "modulate:a", 0, 1)  # De 1 a 0 en 2 segundos

func add_shadow_clone(sprite: Sprite2D, shader: Shader) -> Sprite2D:
    var shadow = Sprite2D.new()
    shadow.texture = sprite.texture
    shadow.position = Vector2(-30, 30)
    shadow.scale = Vector2(1, 1)
    shadow.z_index = -1
    shadow.material = ShaderMaterial.new()
    shadow.material.shader = shader

    sprite.add_child(shadow)
    return shadow

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
