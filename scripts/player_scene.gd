class_name Player

extends Entity

static var PLAYER_SCENE = preload("res://scenes/player_scene.tscn")
const PLAYER_SPRITES = preload("res://resources/sprite-frames/player.tres")

var click_position = Vector2.ZERO
var target_position = Vector2.ZERO

func _ready():
    print("_ready player")
    entity_type = Enums.EntityType.PLAYER
    sprite_frames = PLAYER_SPRITES
    speed = 300
    click_position = global_position
    super._ready()

func initialize():
    global_position = Vector2(-128, -128)

static func spawn_player():
    print("Add the player")
    Global.player = PLAYER_SCENE.instantiate()
    Global.player.initialize()
    Global.world.get_node("Entities").add_child(Global.player)

func _physics_process(_delta):
    left_click_actions()

    update_after_physics_process()

func left_click_actions():
    if Input.is_action_just_pressed("left_click"):
        click_position = get_global_mouse_position()

    if position.distance_to(click_position) > 10:
        target_position = (click_position - position).normalized()
        velocity = target_position * speed
        move_and_slide()
    else:
        velocity = Vector2.ZERO
