class_name Enemy

extends Entity

static var ENEMY_SCENE
const ENEMY1_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster1.tres")
const ENEMY2_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster2.tres")
const TARGET_DESIRED_DISTANCE = 40

@onready var nav_agent: NavigationAgent2D

var current_target_position: Vector2
var target_reached = false

func _ready():
	entity_type = Enums.EntityType.ENEMY
	super._ready()
	speed = 100

	nav_agent = collision_shape.get_node("NavigationAgent2D")
	# nav_agent.debug_enabled = true
	nav_agent.avoidance_enabled = true
	nav_agent.radius = collision_shape.shape.get_rect().size.x * 0.5  # Ajusta según el tamaño de tu CollisionShape2D
	# nav_agent.radius = 0  # Ajusta según el tamaño de tu CollisionShape2D
	nav_agent.neighbor_distance = 64  # Cuánto "ve" a otros enemigos
	nav_agent.max_neighbors = 10 # Máximo de enemigos a considerar para evitar
	nav_agent.target_desired_distance = TARGET_DESIRED_DISTANCE
	nav_agent.path_desired_distance = TARGET_DESIRED_DISTANCE * 0.5

func _process(_delta: float):
	# combat.process(_delta)
	return

func _physics_process(_delta: float):
	if not Global.player:
		return

	if not target_reached:
		var axis = to_local(nav_agent.get_next_path_position()).normalized()
		var intended_velocity = axis * speed
		nav_agent.set_velocity(intended_velocity)

	super.update_after_physics_process()

func _on_timer_timeout():
	if not Global.moomoo:
		return

	var target_position = Global.moomoo.collision_shape.global_position
	var distance = global_position.distance_to(target_position)
	if distance > TARGET_DESIRED_DISTANCE:
		current_target_position = target_position
		target_reached = false
		nav_agent.avoidance_enabled = true
		nav_agent.set_target_position(target_position)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2):
	if safe_velocity.length() > 0.1:  # Evita movimientos espasmódicos
		velocity = safe_velocity
		move_and_slide()
		current_direction = safe_velocity.normalized()

func _on_navigation_agent_2d_target_reached() -> void:
	target_reached = true
	velocity = Vector2.ZERO
	nav_agent.avoidance_enabled = false

func _on_navigation_agent_2d_navigation_finished() -> void:
	target_reached = true
	velocity = Vector2.ZERO
	nav_agent.avoidance_enabled = false

# AUXILIARIES

static func spawn_monsters():
	print("Add some enemies")

	Enemy.spawn_enemy(ENEMY1_SPRITE_FRAMES, Vector2(-230, 200), 1)
	# Enemy.spawn_enemy(ENEMY1_SPRITE_FRAMES, Vector2(-200, 200), 2)
	# Enemy.spawn_enemy(ENEMY1_SPRITE_FRAMES, Vector2(-200, 200), 3)

	# _spawn_enemies_in_direction(Vector2.LEFT)   # Izquierda
	# _spawn_enemies_in_direction(Vector2.RIGHT)  # Derecha
	# _spawn_enemies_in_direction(Vector2.UP)     # Arriba
	# _spawn_enemies_in_direction(Vector2.DOWN)   # Abajo

static func _spawn_enemies_in_direction(direction: Vector2):
	var TILES_DISTANCE = 10
	var MAX_NOISE = 64
	var NUM_ENEMIES = 10

	for i in range(NUM_ENEMIES):
		# Generar ruido independiente para x e y
		var noise_x = randf() * MAX_NOISE * (1 if randf() > 0.5 else -1)  # Positivo o negativo
		var noise_y = randf() * MAX_NOISE * (1 if randf() > 0.5 else -1)  # Positivo o negativo

		# Calcular la posición base según la dirección
		var base_position = direction * (TILES_DISTANCE * 64)

		# Aplicar ruido en ambas coordenadas
		var final_position = base_position + Vector2(noise_x, noise_y)

		# Elegir aleatoriamente el sprite
		var sprite = ENEMY1_SPRITE_FRAMES if randi() % 2 == 0 else ENEMY2_SPRITE_FRAMES

		# Spawnear enemigo
		spawn_enemy(sprite, final_position, i)

static func spawn_enemy(_sprite_frames: SpriteFrames, _position: Vector2, _id: int = 0):
	# TODO: We have to do this because we get an error if use the preload in the beggining
	if !ENEMY_SCENE:
		ENEMY_SCENE = load("res://scenes/enemy_scene.tscn")

	var new_enemy = ENEMY_SCENE.instantiate()
	
	new_enemy.position = _position
	new_enemy.ID = str(_id)
	new_enemy.sprite_frames = _sprite_frames

	Global.world.get_node("Entities").add_child(new_enemy)
	return
