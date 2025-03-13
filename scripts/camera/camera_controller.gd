extends Node

class_name MyCamera

static var camera: Camera2D  # Almacenar la cámara
static var _zoom_level := 1.0  # Zoom inicial
static var _zoom_step := 0.1   # Cantidad de zoom por scroll
static var _zoom_min := 0.5    # Zoom mínimo
static var _zoom_max := 2.0    # Zoom máximo

static func create_camera():
    print("Creating camera")
    MyCamera.camera = Camera2D.new()

    MyCamera.camera.position = Vector2.ZERO
    MyCamera.camera.zoom = Vector2.ONE * 1

    Global.player.add_child(MyCamera.camera)

    MyCamera.camera.make_current() # We need to make it after player.add_child(camera)

static func try_update_zoom(event: InputEvent):
    if event is not InputEventMouseButton:
        return

    if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
        _zoom_level = max(_zoom_level - _zoom_step, _zoom_min)
    elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
        _zoom_level = min(_zoom_level + _zoom_step, _zoom_max)

    camera.zoom = Vector2.ONE * _zoom_level
