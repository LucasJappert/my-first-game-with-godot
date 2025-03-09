extends Entity

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Node2D  # Se establecerá desde el GameController

var last_target_position: Vector2  # Para almacenar la última posición conocida del target
var update_interval: float = 0.5  # Cada cuánto tiempo actualizar la ruta
var time_since_last_update: float = 0.0  # Contador para actualizar

func _ready():
	collision_area_start_position = Vector2(0, 20)
	super._ready()
	speed = 50

	last_target_position = target.position if target else Vector2.ZERO
	nav_agent.avoidance_enabled = true
	# nav_agent.radius = 64  # Ajusta según el tamaño de tu CollisionShape2D
	nav_agent.neighbor_distance = 64*4  # Cuánto "ve" a otros enemigos
	nav_agent.max_neighbors = 30  # Máximo de enemigos a considerar para evitar
	# Conectar la señal para manejar el cálculo de la velocidad evitando colisiones
	nav_agent.velocity_computed.connect(_on_navigation_velocity_computed)

func _on_navigation_velocity_computed(safe_velocity: Vector2):
	# Asignar la velocidad calculada por el agente
	velocity = safe_velocity
	move_and_slide()

	# Actualizar animación
	current_direction = safe_velocity.normalized()
	update_after_physics_process()

func _physics_process(_delta: float):
	if not target:
		return

	# Verificar si el jugador se movió y actualizar la ruta si es necesario
	time_since_last_update += _delta
	if time_since_last_update >= update_interval:
		if last_target_position.distance_to(target.position) > 10:
			nav_agent.set_target_position(target.position)
			last_target_position = target.position
		time_since_last_update = 0.0

	# Solicitar la próxima posición del camino
	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - position).normalized()

	# Asignar la velocidad al agente de navegación
	nav_agent.set_velocity(direction * speed)

func set_target(new_target: Node2D):
	target = new_target
	nav_agent.set_target_position(target.position)
