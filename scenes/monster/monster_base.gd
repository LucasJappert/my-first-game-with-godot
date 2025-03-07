extends Entity

# Dirección inicial
var direction: Vector2 = Vector2.DOWN

func _ready():
	# llamamos al ready de la clase base
	super._ready()


func _physics_process(_delta: float):
	# Movimiento automático del monstruo
	# position += direction * speed * delta
	pass

func _on_area_entered(area):
	# Verifica si el monstruo colisionó con el jugador
	if area.is_in_group("player"):
		print("¡El monstruo colisionó con el jugador!")
		# Aquí puedes agregar lógica adicional, como iniciar un combate
