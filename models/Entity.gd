extends CharacterBody2D

# Entity.gd (Clase base para entidades como Player y Monster)
class_name Entity

@export var sprite_frames: SpriteFrames
@export var speed: float = 100.0
@export var ID: String = ""
@export var collision_area_start_position = Vector2(0, 0)
@export var current_direction: Vector2 = Vector2.ZERO
@export var previous_direction = Vector2.ZERO
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var label: Label = $Label

var current_scale: Vector2 = Vector2(1, 1)
var animated_sprite: AnimatedSprite2D

# Variables para la vida
@export var max_health: int = 100
var current_health: int = max_health
@onready var health_bar: ProgressBar = $HealthBar


func _ready():
	animated_sprite = $AnimatedSprite2D
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.play("walk-down")
	animated_sprite.stop()

	# var texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)

	if health_bar:
		health_bar.size = Vector2(50, 5)
		health_bar.global_position = global_position
		health_bar.global_position = Vector2(global_position.x - health_bar.size.x / 2, global_position.y - 40)
		
		# Configurar estilos (fondo negro y progreso verde)
		var bg_style = StyleBoxFlat.new()
		bg_style.bg_color = Color(0, 0, 0)  # Fondo negro
		health_bar.add_theme_stylebox_override("background", bg_style)
		
		var fg_style = StyleBoxFlat.new()
		fg_style.bg_color = Color(0, 1, 0)  # Progreso verde
		health_bar.add_theme_stylebox_override("fill", fg_style)

		health_bar.max_value = max_health
		health_bar.value = current_health

	set_entity_scale(current_scale)  # Aplicar la escala inicial

func set_entity_scale(scale_factor: Vector2):
	animated_sprite = $AnimatedSprite2D

	animated_sprite.scale.x *= scale_factor.x
	animated_sprite.scale.y *= scale_factor.y
	collision_shape.scale.x *= scale_factor.x
	collision_shape.scale.y *= scale_factor.y
	collision_shape.position.x = collision_area_start_position.x * scale_factor.x
	collision_shape.position.y = collision_area_start_position.y * scale_factor.y

func _process(_delta: float) -> void:
	pass
	# z_index = int(position.y)  # Ordena los objetos según el eje Y

func update_after_physics_process():
	if velocity != Vector2.ZERO:
		animated_sprite.play("walk-down")
	else:
		animated_sprite.stop()

	if previous_direction != current_direction and current_direction != Vector2.ZERO:
		# print("Direction changed from ", previous_direction, " to ", current_direction)
		previous_direction = current_direction
		animated_sprite.flip_h = current_direction.x < 0

# Función para recibir daño
func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)  # Asegura que la vida no sea negativa
	
	if health_bar:
		health_bar.value = current_health
	
	if current_health <= 0:
		die()

# Función para manejar la muerte
func die():
	print("Entity died")
	queue_free()  # Elimina la entidad del juego
