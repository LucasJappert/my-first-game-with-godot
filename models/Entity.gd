extends CharacterBody2D

# Entity.gd (Clase base para entidades como Player y Monster)
class_name Entity

@export var sprite_frames: SpriteFrames
@export var speed: float = 100.0
@export var ID: String = ""
@export var collision_area_start_position = Vector2(0, 0)
@export var current_direction: Vector2 = Vector2.ZERO
@export var previous_direction = Vector2.ZERO

var current_scale: Vector2 = Vector2(1, 1)
var animated_sprite: AnimatedSprite2D

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

func update_after_physics_process():
    if current_direction != Vector2.ZERO:
        animated_sprite.play("walk-down")
    else:
        animated_sprite.stop()

    if previous_direction != current_direction and current_direction != Vector2.ZERO:
        # print("Direction changed from ", previous_direction, " to ", current_direction)
        previous_direction = current_direction
        animated_sprite.flip_h = current_direction.x < 0
