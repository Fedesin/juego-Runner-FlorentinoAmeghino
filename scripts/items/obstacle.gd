class_name Obstacle

extends Item

@onready var shadow = $Shadow
@onready var anim_sprite = $AnimatedSprite2D

func _ready():
    print("nodo: " + name)
    if not ((anim_sprite == null) or (shadow == null)):
        addAnimatedShadow()
        
func _process(delta):
    pass

func addAnimatedShadow():
    shadow.modulate = Color(0, 0, 0, 0.5)  # Color negro con opacidad

func interact() -> void:
    get_parent().screenDamage()
    get_node("../Player/HitSound").play()
    get_parent().damage()
    await get_tree().create_timer(0.2).timeout  # Dura 1 segundo
    get_parent().end_game()

 
