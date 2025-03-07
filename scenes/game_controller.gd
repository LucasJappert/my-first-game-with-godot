extends Node2D

# Ruta de la escena base del monstruo
const MONSTER_BASE_SCENE = preload("res://scenes/monster/MonsterBase.tscn")
const PLAYER_SCENE = preload("res://scenes/player/player.tscn")

# Carga los recursos SpriteFrames directamente en el código
const MONSTER1_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster1.tres")
const MONSTER2_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster2.tres")

const PLAYER_SPRITES = preload("res://resources/sprite-frames/player.tres")

# Función para generar un monstruo en una posición específica
func spawn_monster(sprite_frames: SpriteFrames, id: int = 0):
	# Instancia la escena del monstruo
	var monster = MONSTER_BASE_SCENE.instantiate()
	
	# Establece la posición del monstruo
	var screen = get_viewport_rect().size
	monster.position = Vector2(randf() * screen.x, randf() * screen.y)
	monster.ID = str(id)
	
	# Asigna las animaciones específicas
	monster.sprite_frames = sprite_frames
	
	# Agrega el monstruo a la escena
	add_child(monster)

func spawn_player():
	var player = PLAYER_SCENE.instantiate()
	player.sprite_frames = PLAYER_SPRITES
	add_child(player)

# Ejemplo: Generar monstruos de diferentes tipos
func _ready():
	print("Agregamos el player")
	spawn_player()

	print("Agregamos monsters")
	for i in range(35):  # Genera 5 monstruos
		# Elige un tipo de monstruo al azar
		var monster_type = randi() % 2
		if monster_type == 0:
			spawn_monster(MONSTER1_SPRITE_FRAMES, i)
		else:
			spawn_monster(MONSTER2_SPRITE_FRAMES, i)

# Agregamos la lógica para que se cierre el juego al presionar escape
func _unhandled_input(event):
	# Verifica si se presionó la tecla Escape
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			print("Tecla Escape presionada. Cerrando el juego...")
			get_tree().quit()  # Cierra el juego
