extends Node

@export var physical_attack_range: float = 30.0
@onready var physical_attack_area: Area2D = $PhysicalAttackArea

var last_attack_time: int = 0
const ATTACK_COOLDOWN: int = 500  # Tiempo mínimo entre ataques en milisegundos
var combat: Node
var _collision_shape: CollisionShape2D

func initialize(_combat: Node):
    combat = _combat
    _collision_shape = physical_attack_area.get_node("CollisionShape2D")
    if _collision_shape.shape is CircleShape2D:
        _collision_shape.shape.radius = physical_attack_range

func process(_delta: float):
    _collision_shape.global_position = combat.entity.collision_shape.global_position
    return

func try_attack():
    if not Input.is_action_pressed("physical_attack"):
        return

    var current_time = Time.get_ticks_msec()
    if current_time - last_attack_time < ATTACK_COOLDOWN:
        return

    last_attack_time = current_time  # Actualiza el tiempo del último ataque
    execute_attack()  # Realiza el ataque

func execute_attack():
    var enemies_in_range = []
    for body in physical_attack_area.get_overlapping_bodies():
        if body is Enemy:  # Si el cuerpo es un enemigo, lo agregamos a la lista
            body.combat.take_damage(10)
            enemies_in_range.append(body)

