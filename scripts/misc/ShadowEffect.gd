extends RichTextEffect

const bbcode = "shadow"  # Nombre del BBCode a usar

func _process_custom_fx(char_fx):
    char_fx.offset += Vector2(2, 2)  # Ajusta el desplazamiento de la sombra
    char_fx.color = Color(0, 0, 0, 0.5)  # Color negro semitransparente
    return true
