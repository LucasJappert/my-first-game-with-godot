extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const PLAYER_SCENE = preload("res://scenes/player.tscn")
const WORLD_SCENE = preload("res://scenes/world.tscn")

# Carga los recursos SpriteFrames directamente en el código
const ENEMY1_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster1.tres")
const ENEMY2_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster2.tres")

const PLAYER_SPRITES = preload("res://resources/sprite-frames/player.tres")

var world: Node2D

var camera: Camera2D  # Almacenar la cámara
var zoom_level := 1.0  # Zoom inicial
var zoom_step := 0.1   # Cantidad de zoom por scroll
var zoom_min := 0.5    # Zoom mínimo
var zoom_max := 2.0    # Zoom máximo


var player: Entity

func _ready():

	print("Add the tilemap")
	world = WORLD_SCENE.instantiate()
	add_child(world)

	_spawn_player()

	_create_camera()

	_spawn_monsters()

func _create_camera():
	print("Creating camera")
	# Crear un nuevo nodo Camera2D
	camera = Camera2D.new()
	
	# Configurar la cámara
	camera.position = Vector2.ZERO  # Posición inicial en (0, 0)          # Controla la intensidad del suavizado (valores más pequeños = más suave)
	camera.zoom = Vector2.ONE * 1 # Zoom predeterminado (ajusta si es necesario)

	camera.make_current()
	player.add_child(camera)

func _spawn_enemy(sprite_frames: SpriteFrames, _position: Vector2, id: int = 0):
	var new_enemy = ENEMY_SCENE.instantiate()
	
	# var screen = get_viewport_rect().size
	new_enemy.position = _position # Vector2(randf() * screen.x - screen.x/2, randf() * screen.y - screen.y/2)
	new_enemy.ID = str(id)
	new_enemy.sprite_frames = sprite_frames

	world.get_node("Entities").add_child(new_enemy)

	# Establecer el objetivo como el jugador
	if player:
		new_enemy.set_target(player)

func _spawn_player():
	print("Add the player")
	player = PLAYER_SCENE.instantiate()
	player.sprite_frames = PLAYER_SPRITES
	player.position = Vector2(0, 0)
	world.get_node("Entities").add_child(player)

	return player

func _spawn_monsters():
	print("Add some enemies")

	# _spawn_enemy(ENEMY1_SPRITE_FRAMES, Vector2(-200, 200), 11)

	_spawn_enemies_in_direction(Vector2.LEFT)   # Izquierda
	_spawn_enemies_in_direction(Vector2.RIGHT)  # Derecha
	_spawn_enemies_in_direction(Vector2.UP)     # Arriba
	_spawn_enemies_in_direction(Vector2.DOWN)   # Abajo

func _spawn_enemies_in_direction(direction: Vector2):
	var TILES_DISTANCE = 7
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
		_spawn_enemy(sprite, final_position, i)

# Agregamos la lógica para que se cierre el juego al presionar escape
func _unhandled_input(event):
	# Zoom con scroll del mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level = max(zoom_level - zoom_step, zoom_min)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_level = min(zoom_level + zoom_step, zoom_max)
		
		camera.zoom = Vector2.ONE * zoom_level  # Aplicar el nuevo zoom

	# Verifica si se presionó la tecla Escape
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			print("Tecla Escape presionada. Cerrando el juego...")
			get_tree().quit()  # Cierra el juego
