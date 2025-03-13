class_name MooMoo

extends Entity

static var MOOMOO_SCENE: PackedScene
const MOOMOO_SPRITE_FRAMES = preload("res://resources/sprite-frames/moo-moo.tres")


func _ready():
    sprite_frames = MOOMOO_SPRITE_FRAMES
    entity_type = Enums.EntityType.MOOMOO
    super.set_animated_sprite(Enums.AnimationType.IDLE)

    super._ready()

    global_position = Vector2(0, 0)

static func spawn_moo_moo():
    if !MOOMOO_SCENE:
        MOOMOO_SCENE = load("res://scenes/moomoo_scene.tscn")
    print("Add the MooMoo")
    Global.moomoo = MOOMOO_SCENE.instantiate()
    Global.world.get_node("Entities").add_child(Global.moomoo)


