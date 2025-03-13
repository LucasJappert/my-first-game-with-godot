extends Node2D

const WORLD_SCENE = preload("res://scenes/world.tscn")

func _ready():

	print("Add the tilemap")
	Global.world = WORLD_SCENE.instantiate()
	add_child(Global.world)

	Global.initialize()

	MooMoo.spawn_moo_moo()

	Player.spawn_player()

	MyCamera.create_camera()

	Enemy.spawn_monsters()

