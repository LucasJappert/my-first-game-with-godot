extends Entity

func _ready():
    collision_area_start_position = Vector2(0, 20)
    super._ready()
    speed = 300

func _process(_delta: float):
    label.text = ID + " - " + str(global_position)

func _physics_process(_delta):
    current_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = Vector2.ZERO
    
    if current_direction != Vector2.ZERO:
        # Calcula la nueva posición deseada
        var desired_position = global_position + current_direction * speed * _delta
        
        if is_position_in_navigation(desired_position):
            velocity = current_direction * speed
        else:
            print("La posición deseada está fuera de la zona de navegación.")
        
        move_and_slide()
        for i in get_slide_collision_count():
            var collision = get_slide_collision(i)
            var object = collision.get_collider()
            if object is Entity:
                print("I collided with ", object.ID)

    update_after_physics_process()

func is_position_in_navigation(_position: Vector2):
    var navigation_map = Global.navigation_region.get_navigation_map()
    
    var closest_point = NavigationServer2D.map_get_closest_point(navigation_map, _position)
    var distance_to_closest_point = _position.distance_to(closest_point)
    
    var threshold: float = 5.0  # Umbral de tolerancia (ajusta según sea necesario)
    return distance_to_closest_point <= threshold
