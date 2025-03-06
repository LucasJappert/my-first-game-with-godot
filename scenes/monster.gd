extends CharacterBody2D

# Referencia al nodo AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
    animated_sprite.play("walk-bottom")


func _process(_delta: float):
    # Obtener la entrada del jugador
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    # Mover al personaje (opcional)
    velocity = direction * 300  # Ajusta la velocidad según necesites
    move_and_slide()
    
    # Controlar las animaciones
    if direction != Vector2.ZERO:
        if abs(direction.x) > abs(direction.y):  # Movimiento horizontal
            if direction.x > 0:
                animated_sprite.flip_h = false  # Mirar hacia la derecha
            else:
                animated_sprite.flip_h = true   # Mirar hacia la izquierda
            animated_sprite.play("walk-bottom")  # Reproduce animación lateral
        elif direction.y < 0:  # Movimiento hacia arriba
            animated_sprite.play("walk-top")
        elif direction.y > 0:  # Movimiento hacia abajo
            animated_sprite.play("walk-bottom")
    else:
        animated_sprite.stop()  # Detener la animación si no hay movimiento