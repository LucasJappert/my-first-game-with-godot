extends Node

@onready var _health_bar: ProgressBar = $HealthBar
# @onready var _label: Label = $Label
var entity: Entity

func initialize(_entity: Entity):
    entity = _entity
    if _health_bar:
        _health_bar.size = Vector2(50, 5)
        var bg_style = StyleBoxFlat.new()
        bg_style.bg_color = Color(0, 0, 0)  # Fondo negro
        _health_bar.add_theme_stylebox_override("background", bg_style)
        
        var fg_style = StyleBoxFlat.new()
        fg_style.bg_color = Color(0, 1, 0)  # Progreso verde
        _health_bar.add_theme_stylebox_override("fill", fg_style)

        _health_bar.max_value = entity.combat.max_health
        _health_bar.value = entity.combat.current_health

func _process(_delta: float):
    var global_position = entity.global_position
    _health_bar.global_position = Vector2(global_position.x - _health_bar.size.x / 2, global_position.y - 40)

func increment_health_bar(value: int):
    _health_bar.value += value
    _health_bar.value = max(_health_bar.value, 0)
    
    if _health_bar.value <= 0:
        entity.die()
