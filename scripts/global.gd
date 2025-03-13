extends Node

static var world: Node2D
static var navigation_region: NavigationRegion2D
static var player: Player
static var moomoo: MooMoo

func initialize():
    navigation_region = world.get_node("NavigationRegion2D")
    # print(navigation)
