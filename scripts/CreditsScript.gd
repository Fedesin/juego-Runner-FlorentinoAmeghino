extends Node2D

var my_shader = preload("res://scenes/card_shadow.gdshader")
@onready var container: VBoxContainer = $VBoxContainer
const CREDITS_TEXT_FILE_PATH = "res://assets/text/credits.txt"

var title_font = preload("res://assets/fonts/typeface-mario-world-pixel-font/TypefaceMarioWorldPixelFilledRegular-rgVMx.ttf")
var body_font = preload("res://assets/fonts/pixel-cowboy-font/PixelCowboy-l7we.ttf")

var subtitle_font = title_font
var bold_font = preload("res://assets/fonts/pixel-digivolve-font/PixelDigivolve-mOm9.ttf")

var title_shader = preload("res://scenes/shine.gdshader")

func _ready():
    $Overlay.visible = true
    await get_tree().create_timer(0.5).timeout
    transicion()
    await get_tree().create_timer(1.0).timeout
    
    var aux = 1

    for i in range(1, 6):
        var photo_a = get_node("Photos/PhotoA" + str(i))
        var photo_b = get_node("Photos/PhotoB" + str(i))
        add_shadow_clone(photo_a, my_shader)
        add_shadow_clone(photo_b, my_shader)
        
        movePhoto(photo_a, true)
        await get_tree().create_timer(0.8 * aux).timeout
        movePhoto(photo_b, false)
        await get_tree().create_timer(2.5 * aux).timeout
    
    await get_tree().create_timer(0.5 * aux).timeout
    moveSign($CartelFlorentino)
    
    load_credits(CREDITS_TEXT_FILE_PATH)
    await get_tree().create_timer(3.0 * aux).timeout
    
    await get_tree().process_frame  # Esperar 1 frame para que el layout se actualice
    var altura = $VBoxContainer.size.y
    
    var time = 8.0 * (altura / 500) 
    
    var tween = create_tween()
    tween.tween_property($Camera2D, "position:y", $Camera2D.position.y + altura, time)
    
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
    
func add_image(path: String):
    var texture = load(path)
    if texture:
        var image = TextureRect.new()
        image.texture = texture
        image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        image.custom_minimum_size = Vector2(500, 500)  # ajustá esto si querés otro tamaño
        container.add_child(image)

func add_label(text: String, font_type: String):
    var label = RichTextLabel.new()
    label.bbcode_enabled = true
    label.fit_content = true
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    label.scroll_active = false
    label.clip_contents = false

    text = "[center]" + text + "[/center]"

    label.text = text  # asignar después de modificar

    match font_type:
        "title":
            label.add_theme_font_override("normal_font", title_font)
            label.add_theme_font_size_override("normal_font_size", 40)
            label.add_theme_color_override("default_color", Color(0.913, 0.867, 0.0))
            
        "subtitle":
            label.add_theme_font_override("normal_font", subtitle_font)
            label.add_theme_font_size_override("normal_font_size", 25)
            
        "body":
            label.add_theme_font_override("normal_font", body_font)
            label.add_theme_font_size_override("normal_font_size", 35)
    
    label.add_theme_color_override("default_color", Color(0.913, 0.867, 0.0))       
    label.add_theme_constant_override("outline_size", 15)
    label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))  # sombra negra
    container.add_child(label)


func load_credits(path: String):
    var file := FileAccess.open(path, FileAccess.READ)
    if not file:
        push_error("No se pudo abrir el archivo de créditos.")
        return

    var current_text := ""
    var current_mode := "body"  # Puede ser "title", "subtitle", "body"

    while not file.eof_reached():
        var line := file.get_line().strip_edges()
        
        if line.begins_with("<res://") and line.ends_with(">"):
            if current_text != "":
                add_label(current_text, current_mode)
                current_text = ""
            
            var image_path = line.substr(1, line.length() - 2)  # quitar los < >
            add_image(image_path)
            continue

        elif line.begins_with("# "):  # Título principal
            if current_text != "":
                add_label(current_text, current_mode)
                current_text = ""
            current_mode = "title"
            current_text = "[center]" + line.trim_prefix("# ").strip_edges() + "[/center]"
            add_label(current_text, current_mode)
            current_text = ""
            current_mode = "body"

        elif line.begins_with("## "):  # Subtítulo
            if current_text != "":
                add_label(current_text, current_mode)
                current_text = ""
            current_mode = "subtitle"
            var subtitle = line.trim_prefix("## ").strip_edges()
            current_text = "[u]" + subtitle + "[/u]"
            add_label(current_text, current_mode)
            current_text = ""
            current_mode = "body"

        elif line != "":
            current_text += line + "\n"
        else:
            current_text += "\n"

    if current_text != "":
        add_label(current_text, current_mode)

    file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
