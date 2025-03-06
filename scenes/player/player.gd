extends Node2D

# Exporta una propiedad para asignar SpriteFrames
@export var sprite_frames: SpriteFrames
var animated_sprite: AnimatedSprite2D

# Velocidad de movimiento
@export var speed: float = 150.0

# Dirección actual
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
    scale = Vector2(2, 2)  # Duplica el tamaño
    animated_sprite = $AnimatedSprite2D
    animated_sprite.sprite_frames = sprite_frames
    animated_sprite.play("walk-down")
    # Seteamos la posicion inicial al centro de la pantalla
    position = get_viewport_rect().size / 2


# func _process(_delta: float):
#     # Obtener la entrada del jugador
#     var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
#     # Mover al personaje (opcional)
#     velocity = direction * 300  # Ajusta la velocidad según necesites
#     move_and_slide()
    
#     # Controlar las animaciones
#     if direction != Vector2.ZERO:
#         animated_sprite.play("walk-down")
#     else:
#         animated_sprite.stop()  # Detener la animación si no hay movimiento

func _process(delta):
    # Movimiento básico
    direction = Vector2.ZERO
    if Input.is_action_pressed("ui_up"):
        direction.y -= 1
    if Input.is_action_pressed("ui_down"):
        direction.y += 1
    if Input.is_action_pressed("ui_left"):
        direction.x -= 1
    if Input.is_action_pressed("ui_right"):
        direction.x += 1

    if direction != Vector2.ZERO:
        direction = direction.normalized()
        position += direction * speed * delta

    # Controlar las animaciones
    if direction != Vector2.ZERO:
        animated_sprite.play("walk-down")
    else:
        animated_sprite.stop()  # Detener la animación si no hay movimiento


func _on_area_entered(area):
    # Verifica si el jugador colisionó con un monstruo
    var monster = area.get_parent()
    print("Monstruo colisionado: ", monster.name)

    if area.is_in_group("monsters"):
        print("¡Colisión con un monstruo!")
        # Aquí puedes agregar lógica adicional, como reducir vida o iniciar un combate