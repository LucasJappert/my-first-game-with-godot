extends Node

var world: Node2D
var navigation_region: NavigationRegion2D

func initialize(_world: Node2D):
    world = _world
    navigation_region = _world.get_node("NavigationRegion2D")
    # print(navigation)
