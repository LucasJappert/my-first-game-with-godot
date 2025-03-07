extends Entity


# Dirección actual
var direction: Vector2 = Vector2.ZERO

func _ready():
    super._ready()
    position = get_viewport_rect().size / 2


func _physics_process(_delta):
    direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = Vector2.ZERO
    
    if direction != Vector2.ZERO:
        direction = direction.normalized()
        velocity = direction * speed
        
        # Verificar colisión antes de moverse
        # Using move_and_slide.
        move_and_slide()
        for i in get_slide_collision_count():
            var collision = get_slide_collision(i)
            var object = collision.get_collider()
            if object is Entity:
                print("I collided with ", object.ID)

    if direction != Vector2.ZERO:
        animated_sprite.play("walk-down")
    else:
        animated_sprite.stop()


func _on_area_entered(area):
    # Verifica si el jugador colisionó con un monstruo
    var monster = area.get_parent()
    print("Tipo de objeto: ", monster.get_class())
    print("Monstruo colisionado: ")
    print(str(monster))

    if area.is_in_group("monsters"):
        print("¡Colisión con un monstruo!")
        # Aquí puedes agregar lógica adicional, como reducir vida o iniciar un combate