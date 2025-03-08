extends Node2D

# Ruta de la escena base del monstruo
const ENEMY_SCENE = preload("res://scenes/monster/enemy.tscn")
const PLAYER_SCENE = preload("res://scenes/player/player.tscn")

# Carga los recursos SpriteFrames directamente en el código
const ENEMY1_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster1.tres")
const ENEMY2_SPRITE_FRAMES = preload("res://resources/sprite-frames/monster2.tres")

const PLAYER_SPRITES = preload("res://resources/sprite-frames/player.tres")

func _ready():
	print("Add the player")
	_spawn_player()

	print("Add some enemies")
	for i in range(35):  # Genera 5 monstruos
		# Elige un tipo de monstruo al azar
		var enemy_type = randi() % 2
		if enemy_type == 0:
			_spawn_enemy(ENEMY1_SPRITE_FRAMES, i)
		else:
			_spawn_enemy(ENEMY2_SPRITE_FRAMES, i)

func _spawn_enemy(sprite_frames: SpriteFrames, id: int = 0):
	var new_enemy = ENEMY_SCENE.instantiate()
	
	var screen = get_viewport_rect().size
	new_enemy.position = Vector2(randf() * screen.x, randf() * screen.y)
	new_enemy.ID = str(id)
	new_enemy.sprite_frames = sprite_frames

	add_child(new_enemy)

func _spawn_player():
	var player = PLAYER_SCENE.instantiate()
	player.sprite_frames = PLAYER_SPRITES
	add_child(player)

# Agregamos la lógica para que se cierre el juego al presionar escape
func _unhandled_input(event):
	# Verifica si se presionó la tecla Escape
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			print("Tecla Escape presionada. Cerrando el juego...")
			get_tree().quit()  # Cierra el juego
