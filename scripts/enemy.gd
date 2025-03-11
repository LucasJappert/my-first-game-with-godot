extends Entity

@onready var nav_agent: NavigationAgent2D# = $NavigationAgent2D
var current_target_position: Vector2

var target_reached = false
var player: Entity

const TARGET_DESIRED_DISTANCE = 40

func _ready():
    collision_area_start_position = Vector2(0, 20)
    super._ready()
    speed = 100

    nav_agent = collision_shape.get_node("NavigationAgent2D")
    nav_agent.avoidance_enabled = true
    nav_agent.radius = collision_shape.shape.get_rect().size.x * 0.5  # Ajusta según el tamaño de tu CollisionShape2D
    # nav_agent.radius = 0  # Ajusta según el tamaño de tu CollisionShape2D
    nav_agent.neighbor_distance = 64  # Cuánto "ve" a otros enemigos
    nav_agent.max_neighbors = 10 # Máximo de enemigos a considerar para evitar
    nav_agent.target_desired_distance = TARGET_DESIRED_DISTANCE
    nav_agent.path_desired_distance = TARGET_DESIRED_DISTANCE * 0.5

func set_player(_player: Entity):
    player = _player

func _process(_delta: float):
    # label.text = ID + " - " + str(global_position)
    return

func _physics_process(_delta: float):
    if not player:
        return

    if not target_reached:
        var axis = to_local(nav_agent.get_next_path_position()).normalized()
        var intended_velocity = axis * speed
        nav_agent.set_velocity(intended_velocity)

    super.update_after_physics_process()




func _on_timer_timeout():
    var player_position = player.collision_shape.global_position
    var distance = global_position.distance_to(player_position)
    if distance > TARGET_DESIRED_DISTANCE:
        current_target_position = player_position
        target_reached = false
        nav_agent.avoidance_enabled = true
        nav_agent.set_target_position(player_position)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2):
    if safe_velocity.length() > 0.1:  # Evita movimientos espasmódicos
        velocity = safe_velocity
        move_and_slide()
        current_direction = safe_velocity.normalized()

func _on_navigation_agent_2d_target_reached() -> void:
    target_reached = true
    velocity = Vector2.ZERO
    nav_agent.avoidance_enabled = false
    print("Target reached by enemy %s" % ID)


func _on_navigation_agent_2d_navigation_finished() -> void:
    target_reached = true
    velocity = Vector2.ZERO
    nav_agent.avoidance_enabled = false
    print("Target reached by enemy %s" % ID)
