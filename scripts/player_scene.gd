class_name Player

extends Entity

static var PLAYER_SCENE = preload("res://scenes/player_scene.tscn")
const PLAYER_SPRITES = preload("res://resources/sprite-frames/player.tres")


func _ready():
    entity_type = Enums.EntityType.PLAYER
    sprite_frames = PLAYER_SPRITES
    super._ready()
    speed = 300

func initialize():
    global_position = Vector2(-128, -128)



static func spawn_player():
    print("Add the player")
    Global.player = PLAYER_SCENE.instantiate()
    Global.player.initialize()
    Global.world.get_node("Entities").add_child(Global.player)

func _process(_delta: float):
    combat.try_physical_attack()
    super._process(_delta)

func _physics_process(_delta):
    current_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = Vector2.ZERO
    
    if current_direction != Vector2.ZERO:
        # Calcula la nueva posición deseada
        var desired_position = global_position + current_direction * speed * _delta
        
        if is_position_in_navigation(desired_position):
            velocity = current_direction * speed
        else:
            print("La posición deseada está fuera de la zona de navegación.")
        
        move_and_slide()

    update_after_physics_process()

