extends Entity

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Node2D

var last_target_position: Vector2
var update_interval: float = 0.2
var time_since_last_update: float = 0.0

func _ready():
    collision_area_start_position = Vector2(0, 20)
    super._ready()

    last_target_position = target.position if target else Vector2.ZERO
    nav_agent.radius = 32  # Ajusta según el tamaño del enemigo
    nav_agent.avoidance_enabled = false  # Desactivamos la evitación automática

func _physics_process(_delta: float):
    if not target:
        return

    # Actualizar la ruta si es necesario
    time_since_last_update += _delta
    if time_since_last_update >= update_interval:
        if last_target_position.distance_to(target.position) > 10:
            nav_agent.set_target_position(target.position)
            last_target_position = target.position
        time_since_last_update = 0.0

    # Obtener la próxima posición en la ruta
    var next_path_position = nav_agent.get_next_path_position()
    if next_path_position != Vector2.ZERO:
        var direction = (next_path_position - position).normalized()

        # Mover hacia la siguiente posición
        position += direction * speed * _delta

        # Actualizar animación
        current_direction = direction
        update_after_physics_process()

func set_target(new_target: Node2D):
    target = new_target
    nav_agent.set_target_position(target.position)