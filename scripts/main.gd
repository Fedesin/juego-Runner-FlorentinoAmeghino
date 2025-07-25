extends Node

# Cat variant scenes
@export var cat_variants: Array[PackedScene]
@export var blue_cat: PackedScene
@export var green_cat: PackedScene
@export var pink_cat: PackedScene

# Cat variant buffs
const CAT_BONUS := 2
const GREEN_CAT_BONUS := 3
const PINK_CAT_BONUS := 5
const BLUE_CAT_BONUS := 10

# Regular cats
var cats_spawned: Array[Cat]
var cats_owned: int
# Green cats
var green_cats_spawned: Array[Cat]
var green_cats_owned: int
# Pink cats
var pink_cats_spawned: Array[Cat]
var pink_cats_owned: int
# Blue cats
var blue_cats_spawned: Array[Cat]
var blue_cats_owned: int

@export var item_variants: Array[PackedScene]
var items_spawned: Array[Item]
var last_item_spawned: Item

# Initial positions
const PLAYER_START_POS := Vector2i(150, 444)
const CAM_START_POS := Vector2i(576, 324)

# Score
var score: int
const SCORE_MODIFIER := 10
var high_score: int

var money := Money.new()
var earned: int

# Player moving speed
var speed: float
const START_SPEED := 7.0
const MAX_SPEED := 25.0
const PROSTO_SPEED := 100
const SPEED_MODIFIER := 10000

var screen_size: Vector2i
var game_running: bool

var difficulty: int
const MAX_DIFFICULTY := 2

var ground_height: int
var ground_scale: int

var levels = Levels.new()

var pausa = false
var cutscene_playing = false

signal reset_game
signal start_game
signal game_end

var fosil_scene = load("res://scenes/cutscene.tscn")
var credits_scene = preload("res://scenes/credits.tscn")

var initial_shadow_y = 0

@export var megaterio: PackedScene
var megaterio_companion: Megaterio

func _ready() -> void:
  #$Camera2D/RunningMusic.volume_db = 6
  $Camera2D/DamageFrame.visible = true

  $Camera2D/RunningMusic.play()

  initial_shadow_y = $Player.global_position.y + 40
  screen_size = get_viewport().size
  ground_height = $Ground/Sprite2D.texture.get_height()
  ground_scale = $Ground/Sprite2D.scale.y
  $GameOver/Button.pressed.connect(new_game)
  $Camera2D/DamageFrame.modulate.a = 0
  new_game()

func playCutscene():
  var previousSpeed = speed
  pausa = true
  speed = 0
  $Cutscene.visible = true
  $Camera2D/Cutscene_sound1.play()
  $Cutscene.playCutscene(getCurrentLevel().get_animal(), $Camera2D/Cutscene_sound2)
    #speed = previousSpeed

func getCurrentLevel() -> Level:
  return levels.get_level()
    
func damage():
  var shader_material = $Player/AnimatedSprite2D.material
  var tween = get_tree().create_tween()
  shader_material.set_shader_parameter("shock_progress", 1.0)
  shader_material.set_shader_parameter("amplitude", 0.2)  # Antes estaba en 0.5, ahora lo reducimos
    # Interpola de 1.0 a 0.0 en 0.5 segundosj
  tween.tween_property(shader_material, "shader_parameter/shock_progress", 0.0, 0.5)
  tween.tween_property(shader_material, "shader_parameter/amplitude", 0.0, 0.5)  # Reduce amplitud
    
func screenDamage():
  var tween = get_tree().create_tween()
  $Camera2D/DamageFrame.modulate.a = 1
  tween.tween_property($Camera2D/DamageFrame, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    
func passLevel():
  levels.next()
  pausa = false
  await get_tree().create_timer(0.3).timeout
  cutscene_playing = false

func _process(delta: float) -> void:
  $Player/Shadow.global_position.x = $Player.global_position.x
  $Player/Shadow.global_position.y = initial_shadow_y # fijá esta constante o cálculo con el nivel del suelo
  # Show in-game menu when <ESC> is pressed
  if Input.is_action_just_pressed("menu"):
    $Menu.show()
    get_tree().paused = true
    return

  # Start the game if received input to do so, otherwise halt the game loop
  if not game_running:
    if Input.is_action_pressed("jump") and (not cutscene_playing):
        game_running = true
        $HUD/StartLabel.hide()
        var tween = get_tree().create_tween()
        tween.tween_property($HUD/TitleLabel, "modulate:a", 0, 2.5)
        start_game.emit()
    else:
        return

  if not pausa:
    speed = (
        clamp(START_SPEED + score / SPEED_MODIFIER, START_SPEED, MAX_SPEED) * PROSTO_SPEED * delta
    )
    adjust_difficulty()
    generate_item()

  # Move the player forward
  $Player.position.x += speed
  $Camera2D.position.x += speed

  # Update the score
  score += speed
  show_score()

  var visible_size = $Camera2D.get_viewport_rect().size / $Camera2D.zoom
  var camera_x = $Camera2D.global_position.x
  var ground_x = $Ground.global_position.x
  var camera_width = ($Camera2D.get_viewport_rect().size.x / $Camera2D.zoom.x)

  # Si la cámara se alejó más de 1.5 veces el ancho de la cámara, reposicionar
  if camera_x - ground_x > camera_width * 1.5:
    $Ground.global_position.x += camera_width

  # Remove the items_spawned that have gone off screen
  for obstacle in items_spawned:
    if obstacle.position.x < ($Camera2D.position.x - screen_size.x):
        remove_item(obstacle)


func new_game() -> void:
  # Reset variables
  speed = START_SPEED
  score = 0
  earned = 0
  show_score()
  get_tree().paused = false
  game_running = false
  difficulty = 0

  generate_cat()
  # Delete all items_spawned
  for obstacle in items_spawned:
    obstacle.queue_free()
  items_spawned.clear()
  last_item_spawned = null

  # Reset nodes
  $Player.position = PLAYER_START_POS
  $Player.velocity = Vector2i(0, 0)
  $Camera2D.position = CAM_START_POS
  $Ground.position = Vector2i(0, 0)

  # Reset HUD
  $HUD/StartLabel.show()
  $GameOver.hide()
  #$RunningMusic.play()
  #$RunningMusic/AnimationPlayer.play("ost_fade_in")
  var tween = get_tree().create_tween()
  tween.tween_property($HUD/TitleLabel, "modulate:a", 1, 0)
  var level_title = levels.get_level().get_title()
  
  if level_title == "<FIN>" :
    get_tree().change_scene_to_packed(credits_scene)
    
  $HUD/TitleLabel.text = level_title

  change_background()
  if getCurrentLevel().companion:
    add_megaterio()
  else:
    remove_megaterio()
  reset_game.emit()


func show_score() -> void:
  $HUD/ScoreLabel.text = "Huesos: " + str(earned)
  check_high_score()

func change_background():
  var pathBackground = "res://assets/sprites/backgrounds/" + levels.get_level().get_scene() + "/background.png"
  var pathGround = "res://assets/sprites/backgrounds/" + levels.get_level().get_scene() + "/ground.png"
  var pathLayer1 = "res://assets/sprites/backgrounds/" + levels.get_level().get_scene() + "/layer1.png"
  var pathLayer3 = "res://assets/sprites/backgrounds/" + levels.get_level().get_scene() + "/layer3.png"
  $Background/Sprite2D.texture = load(pathBackground)
  $Ground/Sprite2D.texture = load(pathGround)
  $Background/ParallaxLayer/Sprite2D.texture = load(pathLayer1)
  $Background/ParallaxLayer2/Sprite2D.texture = load(pathLayer3)

func check_high_score() -> void:
  if score > high_score:
    high_score = score
    $HUD/HighScoreLabel.text = "HIGHSCORE: " + str(high_score / SCORE_MODIFIER)

func generate_item() -> void:
  if not items_spawned.is_empty():
    if last_item_spawned != null:
        if last_item_spawned.position.x >= score + randi_range(300, 500):
            return
  var item_type := item_variants[randi() % item_variants.size()]
  var item: Item

  var max_items := difficulty + 1
  for i in randi() % max_items + 1:
    item = item_type.instantiate()
    if item is Coin:
        item.set_animal(levels.get_level().get_animal())

    # Get item's sprite pixel lengths
    var item_height: int = item.get_node("Sprite2D").texture.get_height()
    var item_scale: Vector2i = item.get_node("Sprite2D").scale
    # Calculate the position accordingly
    var item_x: int = screen_size.x + $Player.position.x + (i * 100) + (speed / MAX_SPEED) * 150
    var item_y: int = (
      screen_size.y
      - (ground_height * ground_scale)
      - (item_height * item_scale.y / 2)
      + (2 * item_scale.y)
    )
    
    add_item(item, item_x, item_y + -200)


func add_item(item: Item, x: int, y: int) -> void:
  item.position = Vector2i(x, y)
  item.main = self
  item.body_entered.connect(item.on_hit)
  last_item_spawned = item
  add_child(item)
  items_spawned.append(item)


func remove_item(item: Item):
  items_spawned.erase(item)
  item.queue_free()


func adjust_difficulty() -> void:
  difficulty = clamp(score / SPEED_MODIFIER, 0, MAX_DIFFICULTY)


func end_game() -> void:
  get_tree().paused = true
  game_running = false
  #$RunningMusic/AnimationPlayer.play("ost_fade_out")

  # Calculate how much player gets from just running
  var final_score: int = score / SCORE_MODIFIER / 5
  earned += final_score * (speed / START_SPEED)
  earned *= (
    clamp(cats_owned, 1, 999)
    * clamp(green_cats_owned * GREEN_CAT_BONUS, 1, 999)
    * clamp(pink_cats_owned * PINK_CAT_BONUS, 1, 999)
    * clamp(blue_cats_owned * BLUE_CAT_BONUS, 1, 999)
  )
  money.add(earned)

  $GameOver/Earned.text = "+" + Money.new(earned).print()
  $GameOver/Earned.modulate = Color.GREEN
  $GameOver/Earned.reset()
  $GameOver/Money.text = money.print()
  #$GameOver.show()
  game_end.emit()
  new_game()


func generate_cat() -> void:
  if green_cats_spawned.size() < green_cats_owned:
    for i in green_cats_owned - green_cats_spawned.size():
        green_cats_spawned.append(add_cat(green_cat))
  if pink_cats_spawned.size() < pink_cats_owned:
    for i in pink_cats_owned - pink_cats_spawned.size():
        pink_cats_spawned.append(add_cat(pink_cat))
  if blue_cats_spawned.size() < blue_cats_owned:
    for i in blue_cats_owned - blue_cats_spawned.size():
        blue_cats_spawned.append(add_cat(blue_cat))
  if cats_spawned.size() < cats_owned:
    for i in cats_owned - cats_spawned.size():
        var cat_type = cat_variants[randi() % cat_variants.size()]
        cats_spawned.append(add_cat(cat_type))


func add_cat(cat_type: PackedScene) -> Cat:
  var cat: Cat = cat_type.instantiate()
  $Camera2D.add_child(cat)

  cat.global_position.x = $Player.position.x - randi_range(45, PLAYER_START_POS.x)
  cat.global_position.y = PLAYER_START_POS.y

  return cat

func add_megaterio():
  if not megaterio_companion:
    megaterio_companion = megaterio.instantiate()
    $Camera2D.add_child(megaterio_companion)
    megaterio_companion.global_position.x = $Player.position.x - randi_range(45, PLAYER_START_POS.x)
    megaterio_companion.global_position.y = PLAYER_START_POS.y
    spawn_label_above(megaterio_companion, "MEGATERIO\nCOMPAÑERO!!")
    
func spawn_label_above(target_node: Node2D, text: String):
    var label = RichTextLabel.new()
    label.name = "MegaterioLabel"
    var body_font = preload("res://assets/fonts/pixel-cowboy-font/PixelCowboy-l7we.ttf")
    label.bbcode_enabled = true
    label.fit_content = true
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    label.scroll_active = false
    label.clip_contents = false
    label.size.x = 300
    label.rotation = 0.2
    
    text = "[center]" + text + "[/center]"
    
    label.text = text  # asignar después de modificar
    
    label.add_theme_font_override("normal_font", body_font)
    label.add_theme_font_size_override("normal_font_size", 30)
    label.add_theme_color_override("default_color", Color(0.913, 0.867, 0.0))       
    label.add_theme_constant_override("outline_size", 10)
    label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))  # sombra negra
    
    add_child(label)  # agregalo al mismo padre o a un contenedor adecuado

    # Posicionarlo un poco más arriba (por ejemplo, 20 píxeles)
    label.position = target_node.global_position + Vector2(-55, -230)
    make_label_pulse(label)
    
func make_label_pulse(label: Control):
    var tween = create_tween()
    tween.set_loops()  # hace que se repita infinitamente
    tween.set_trans(Tween.TRANS_SINE)
    tween.set_ease(Tween.EASE_IN_OUT)

    # Escalar a 1.2 en 0.5s y volver a 1.0 en 0.5s
    tween.tween_property(label, "scale", Vector2(1.05, 1.05), 0.5)
    tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.5)

func remove_megaterio():
    if megaterio_companion and megaterio_companion.get_parent():
        megaterio_companion.queue_free()
        megaterio_companion = null
        var label = get_node_or_null("MegaterioLabel")
        if label:
            label.queue_free()
