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
        velocity = direction * speed
        
        move_and_slide()
        for i in get_slide_collision_count():
            var collision = get_slide_collision(i)
            var object = collision.get_collider()
            if object is Entity:
                print("I collided with ", object.ID)
        
        # var collision = move_and_collide(velocity * _delta)
        # if collision:
        #     var object = collision.get_collider()
        #     if object is Entity:
        #         print("I collided with ", object.ID)
        #     velocity = Vector2.ZERO  # Detiene el movimiento completamente


    if direction != Vector2.ZERO:
        animated_sprite.play("walk-down")
    else:
        animated_sprite.stop()
