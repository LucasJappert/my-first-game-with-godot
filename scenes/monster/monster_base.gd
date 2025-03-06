extends Node2D

# Exporta una propiedad para asignar SpriteFrames
@export var sprite_frames: SpriteFrames

# Velocidad de movimiento
@export var speed: float = 100.0
@export var ID: String = ""

# Dirección inicial
var direction: Vector2 = Vector2.DOWN

func _ready():
	scale = Vector2(2, 2)  # Duplica el tamaño
	# Asigna los SpriteFrames al AnimatedSprite2D si están disponibles
	if sprite_frames and has_node("AnimatedSprite2D"):
		var animated_sprite = $AnimatedSprite2D
		animated_sprite.sprite_frames = sprite_frames
		
		# Verifica si existe la animación "walk_down" en los SpriteFrames
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("walk_down"):
			animated_sprite.play("walk_down")


func _process(_delta: float):
	# Movimiento automático del monstruo
	# position += direction * speed * delta
	pass

func _on_area_entered(area):
	# Verifica si el monstruo colisionó con el jugador
	if area.is_in_group("player"):
		print("¡El monstruo colisionó con el jugador!")
		# Aquí puedes agregar lógica adicional, como iniciar un combate
