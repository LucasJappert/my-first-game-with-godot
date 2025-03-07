extends CharacterBody2D

# Entity.gd (Clase base para entidades como Player y Monster)
class_name Entity

@export var sprite_frames: SpriteFrames
@export var speed: float = 100.0
@export var ID: String = ""

var scale_factor: float = 2.0  # Escala inicial
var animated_sprite: AnimatedSprite2D

func _ready():
    animated_sprite = $AnimatedSprite2D
    animated_sprite.sprite_frames = sprite_frames
    animated_sprite.play("walk-down")
    animated_sprite.stop()

    set_entity_scale(scale_factor)  # Aplicar la escala inicial

func set_entity_scale(factor: float):
    scale_factor = factor
    animated_sprite = $AnimatedSprite2D
    var collision_shape = $CollisionShape2D

    animated_sprite.scale = Vector2(scale_factor, scale_factor)
    collision_shape.scale = Vector2(scale_factor, scale_factor)

    # # Imprimir las escalas globales
    # print("Escala global de AnimatedSprite2D: ", animated_sprite.global_transform.get_scale())
    # print("Escala global de CollisionShape2D: ", collision_shape.scale)