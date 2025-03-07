extends CharacterBody2D

# Entity.gd (Clase base para entidades como Player y Monster)
class_name Entity

@export var sprite_frames: SpriteFrames
@export var speed: float = 100.0
@export var ID: String = ""

var current_scale: Vector2 = Vector2(5, 5)
var animated_sprite: AnimatedSprite2D
const collision_area_start_position = Vector2(0, 5)

func _ready():
    animated_sprite = $AnimatedSprite2D
    animated_sprite.sprite_frames = sprite_frames
    animated_sprite.play("walk-down")
    animated_sprite.stop()

    set_entity_scale(current_scale)  # Aplicar la escala inicial

func set_entity_scale(scale_factor: Vector2):
    animated_sprite = $AnimatedSprite2D
    var collision_shape = $CollisionShape2D

    animated_sprite.scale.x *= scale_factor.x
    animated_sprite.scale.y *= scale_factor.y
    collision_shape.scale.x *= scale_factor.x
    collision_shape.scale.y *= scale_factor.y
    collision_shape.position.x = collision_area_start_position.x * scale_factor.x
    collision_shape.position.y = collision_area_start_position.y * scale_factor.y

func _process(_delta: float) -> void:
    z_index = int(position.y)  # Ordena los objetos según el eje Y
