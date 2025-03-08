extends Entity

func _ready():
    collision_area_start_position = Vector2(0, 20)
    super._ready()
    position = get_viewport_rect().size / 2
    speed = 200

func _physics_process(_delta):
    current_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = Vector2.ZERO
    
    if current_direction != Vector2.ZERO:
        velocity = current_direction * speed
        
        move_and_slide()
        for i in get_slide_collision_count():
            var collision = get_slide_collision(i)
            var object = collision.get_collider()
            if object is Entity:
                print("I collided with ", object.ID)

    update_after_physics_process()

