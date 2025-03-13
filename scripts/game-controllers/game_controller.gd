extends Node2D

const WORLD_SCENE = preload("res://scenes/world.tscn")

func _ready():

	print("Add the tilemap")
	Global.world = WORLD_SCENE.instantiate()
	add_child(Global.world)

	Global.initialize()

	Player.spawn_player()

	MyCamera.create_camera()

	Enemy.spawn_monsters()
