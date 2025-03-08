extends Entity

# Dirección inicial
var direction: Vector2 = Vector2.DOWN

func _ready():
	collision_area_start_position = Vector2(0, 20)
	super._ready()


func _physics_process(_delta: float):
	pass

func _on_area_entered(area):
	# Verifica si el monstruo colisionó con el jugador
	if area.is_in_group("player"):
		print("¡El monstruo colisionó con el jugador!")
