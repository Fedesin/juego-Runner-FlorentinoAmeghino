extends CharacterBody2D

const INPUT_BUFFER := 0.1  # time in seconds
var buffer_timer := 0.0
var buffer := false

const JUMP_VELOCITY := -1500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
    buffer = false
    $AnimatedSprite2D.play("idle")
    return
