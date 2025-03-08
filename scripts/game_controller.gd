extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const PLAYER_SCENE = preload("res://scenes/player.tscn")
const TILEMAP_SCENE = preload("res://scenes/world.tscn")

# Carga los recursos SpriteFrames directamente en el código
const ENEMY1_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster1.tres")
const ENEMY2_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster2.tres")

const PLAYER_SPRITES = preload("res://resources/sprite-frames/player.tres")

var camera: Camera2D  # Almacenar la cámara
var zoom_level := 1.0  # Zoom inicial
var zoom_step := 0.1   # Cantidad de zoom por scroll
var zoom_min := 0.5    # Zoom mínimo
var zoom_max := 2.0    # Zoom máximo

func _ready():
	print("Creating camera")
	camera = _create_camera()

	print("Add the tilemap")
	var terrain = TILEMAP_SCENE.instantiate()
	add_child(terrain)

	_spawn_player()

	print("Add some enemies")
	for i in range(35):  # Genera 5 monstruos
		# Elige un tipo de monstruo al azar
		var enemy_type = randi() % 2
		if enemy_type == 0:
			_spawn_enemy(ENEMY1_SPRITE_FRAMES, i)
		else:
			_spawn_enemy(ENEMY2_SPRITE_FRAMES, i)

func _create_camera():
	# Crear un nuevo nodo Camera2D
	camera = Camera2D.new()
	
	# Configurar la cámara
	camera.position = Vector2.ZERO  # Posición inicial en (0, 0)          # Controla la intensidad del suavizado (valores más pequeños = más suave)
	camera.make_current()
	camera.zoom = Vector2.ONE * 1 # Zoom predeterminado (ajusta si es necesario)

	return camera

func _spawn_enemy(sprite_frames: SpriteFrames, id: int = 0):
	var new_enemy = ENEMY_SCENE.instantiate()
	
	var screen = get_viewport_rect().size
	new_enemy.position = Vector2(randf() * screen.x - screen.x/2, randf() * screen.y - screen.y/2)
	new_enemy.ID = str(id)
	new_enemy.sprite_frames = sprite_frames

	add_child(new_enemy)

func _spawn_player():
	print("Add the player")
	var player = PLAYER_SCENE.instantiate()
	player.sprite_frames = PLAYER_SPRITES
	player.position = Vector2(0, 0)
	# Asignar el jugador como objetivo de la cámara
	if camera:
		player.add_child(camera)
	add_child(player)

	return player

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
