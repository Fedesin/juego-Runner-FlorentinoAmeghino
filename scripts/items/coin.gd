extends Item

class_name Coin

const frases = ["Wow!", "Increible!", "Solido!","Asombroso!","Buen trabajo!"]

var animal = ""

func interact() -> void:
    $PickupSound.play()
    $AnimatedSprite2D.hide()
    $AnimationPlayer.play("fade")

    var earned: int = 1
    main.earned += earned

    $AmountEarned.position.x += randi_range(-10, 10)
    $AmountEarned.position.y += randi_range(-10, 10)
    var index = randi_range(0,(frases.size() - 1))
    $AmountEarned.text = frases[index]
    $AmountEarned.show()
    
func set_animal(nombre) -> void:
    animal = nombre
    
func get_animal() -> String:
    return animal
