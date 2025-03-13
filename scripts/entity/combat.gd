extends Node

# Variables para la vida
@export var max_health: int = 100
@export var physical_attack_range: float = 30.0
@onready var physical_attack: Node = $PhysicalAttack
var current_health: int = max_health
var entity: Entity


func initialize(_entity: Entity):
    entity = _entity
    physical_attack.initialize(self)

func process(_delta: float):
    physical_attack.process(_delta) 

func try_physical_attack():
    physical_attack.try_attack()

# Función para recibir daño
func take_damage(amount: int):
    entity.ui_overlay.increment_health_bar(-amount)
