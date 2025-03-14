extends CharacterBody2D

# Entity.gd (Clase base para entidades como Player y Monster)
class_name Entity

@export var sprite_frames: SpriteFrames
@export var speed: float = 100.0
@export var ID: String = ""
@export var collision_area_start_position = Vector2(0, 0)
@export var current_direction: Vector2 = Vector2.ZERO
@export var previous_direction = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var combat = $Combat
@onready var ui_overlay = $UIOverlay

var current_scale: Vector2 = Vector2(1, 1)
var animated_sprite: AnimatedSprite2D
var entity_type: int


func _ready():
    print("_ready entity")
    if not animated_sprite:
        set_animated_sprite(Enums.AnimationType.WALK_DOWN)

    # collision_area_start_position = Vector2(0, 20)

    _set_entity_scale(current_scale)

    combat.initialize(self)

    ui_overlay.initialize(self)

func set_animated_sprite(animation_type: String):
    animated_sprite = $AnimatedSprite2D
    animated_sprite.sprite_frames = sprite_frames
    animated_sprite.play(animation_type)
    if entity_type != Enums.EntityType.MOOMOO:
        animated_sprite.stop()

func _set_entity_scale(scale_factor: Vector2):
    animated_sprite.scale.x *= scale_factor.x
    animated_sprite.scale.y *= scale_factor.y
    # collision_shape.scale.x *= scale_factor.x
    # collision_shape.scale.y *= scale_factor.y
    # collision_shape.position.x = collision_area_start_position.x * scale_factor.x
    # collision_shape.position.y = collision_area_start_position.y * scale_factor.y

func _process(_delta: float) -> void:
    ui_overlay._process(_delta)
    combat.process(_delta)

    # Allow attacks for player and enemies (not moomoo)
    if entity_type in [Enums.EntityType.ENEMY, Enums.EntityType.PLAYER]:
        combat.try_physical_attack(self)

func update_after_physics_process():
    if not animated_sprite:
        return

    if velocity != Vector2.ZERO:
        animated_sprite.play(Enums.AnimationType.WALK_DOWN)
    else:
        animated_sprite.stop()

    if previous_direction != current_direction and current_direction != Vector2.ZERO:
        # print("Direction changed from ", previous_direction, " to ", current_direction)
        previous_direction = current_direction
        animated_sprite.flip_h = current_direction.x < 0

func die():
    print("Entity died")
    queue_free()  # Elimina la entidad del juego

func is_position_in_navigation(_position: Vector2):
    var navigation_map = Global.navigation_region.get_navigation_map()
    
    var closest_point = NavigationServer2D.map_get_closest_point(navigation_map, _position)
    var distance_to_closest_point = _position.distance_to(closest_point)
    
    var threshold: float = 5.0  # Umbral de tolerancia (ajusta según sea necesario)
    return distance_to_closest_point <= threshold