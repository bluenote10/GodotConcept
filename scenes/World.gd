extends Node2D

var WALL_TEXTURE = preload("res://textures/caster.png")


func __set_transform_rect(rect, p1, p2, width=1.0):
    var center = 0.5 * (p1 + p2)
    var delta = p2 - p1
    var rotation = atan2(delta.x, delta.y)
    
    # Subtract half a pixel ensures that the texture aligns with physical pixels
    rect.rect_position = center
    rect.rect_rotation = rotation
    rect.rect_size = Vector2(width, delta.length())
    
    rect.anchor_left = 0.5
    rect.anchor_top = 0.5


func compute_transform(p1, p2, width=1.0):
    var center = 0.5 * (p1 + p2)
    var delta = p2 - p1
    var rotation = atan2(delta.y, delta.x)
    
    var transform = Transform2D()
    transform *= Transform2D().translated(center)
    transform *= Transform2D().rotated(rotation)
    transform *= Transform2D().scaled(Vector2(delta.length(), width))
    
    return transform


func generate_wall(p1, p2):
    var transform = compute_transform(p1, p2)
    
    var wall = StaticBody2D.new() # Node2D.new()
    wall.transform = transform
    
    # Add light occluder
    var occluder_polygon = OccluderPolygon2D.new()
    occluder_polygon.polygon = PoolVector2Array([
        Vector2(-0.5, -1),
        Vector2(+0.5, -1),
        Vector2(+0.5, +1),
        Vector2(-0.5, +1)])
    
    var occluder = LightOccluder2D.new()
    occluder.occluder = occluder_polygon
    wall.add_child(occluder)
    
    # Add collider
    var shape = RectangleShape2D.new()
    shape.extents = Vector2(0.5, 0.5)
    
    var collider = CollisionShape2D.new()
    collider.shape = shape
    wall.add_child(collider)
    
    wall.collision_layer = 1 | 2
    wall.add_to_group("walls")
    
    return wall


func generate_wall_shadow_world(p1, p2):
    var transform = compute_transform(p1, p2)
    
    var wall = LightOccluder2D.new()
    wall.transform = transform
    
    # Add light occluder
    var occluder_polygon = OccluderPolygon2D.new()
    occluder_polygon.polygon = PoolVector2Array([
        Vector2(-0.5, -1),
        Vector2(+0.5, -1),
        Vector2(+0.5, +1),
        Vector2(-0.5, +1)])
    
    wall.occluder = occluder_polygon

    return wall
    
    
func generate_walls_random():

    var num_walls = 100
    
    for i in num_walls:
        
        var p1 = Vector2(rand_range(-1000, 1000), rand_range(-1000, 1000))
        var p2 = Vector2(p1.x + rand_range(-100, 100), p1.y + rand_range(-100, 100))
        #var p1 = Vector2(40, 30)
        #var p2 = Vector2(-100, 200)

        var wall = generate_wall(p1, p2)
        add_child(wall)


func generate_walls(world):
    
    print("World has %d polygons" % world.size())
    for polygon in world:
        var exterior = polygon[0]
        var interiors = polygon[1]

        print("Ignoring %d polygon holes" % interiors.size())
        
        for i in exterior.size() - 1:
            var p1 = exterior[i]
            var p2 = exterior[i + 1]
            var wall = generate_wall(p1, p2)
            add_child(wall)

            var wall_shadow = generate_wall_shadow_world(p1, p2)
            $ShadowWorldViewport.add_child(wall_shadow)

        var poly = load("res://scenes/PolygonRenderer.tscn").instance()
        poly.width = 3.0
        poly.points = exterior
        add_child(poly)        
    """
    for polygon in world:
        var points = PoolVector2Array.new()
        for
    """ 


func generate_enemies():
    var num_enemies = 30
    
    for i in num_enemies:
        var enemy = load("res://scenes/Enemy.tscn").instance()
        enemy.position = Vector2(rand_range(-1000, 1000), -rand_range(-1000, 1000))
        enemy.enemy_radius = rand_range(8, 16)
        enemy.max_speed = rand_range(50, 220)
        add_child(enemy)
    
    

func _ready():
    var rust_world = $"../RustWorld"
    var world = rust_world.get_world()
    print(world)
    
    generate_walls(world)
    generate_enemies()
    
    if false:    
        var debug1 = load("res://scenes/DebugNode2D.tscn").instance()
        #debug1.position = Vector2(1024, 1024)
        #debug1.position = Vector2(512, 512)
        debug1.position = Vector2(0, 0)
        debug1.scale = Vector2(10, 10)
        $ShadowWorldViewport.add_child(debug1)
            
    
func _physics_process(_delta):
    var space_state = get_world_2d().direct_space_state

    var player = $"../Player"
    
    $ShadowWorldViewport/Light2D.position = player.position
    $ShadowWorldViewport/Light2D.rotation = player.rotation
    # $ShadowWorldViewport.get_texture().get_data().save_png("shadows.png")

    if false:
        # Old implementation based on raytracing + line sprites

        var walls = get_tree().get_nodes_in_group("walls")
        for wall in walls:
            if wall.has_node("Sprite"):
                continue
    
            var test_point = wall.position
            var result = space_state.intersect_ray(player.position, test_point, [], 2)
            if result and result.rid == wall.get_rid():
                var rect = Sprite.new()
                rect.texture = WALL_TEXTURE
                rect.scale = Vector2(1 / WALL_TEXTURE.get_data().get_size().x, 10 / WALL_TEXTURE.get_data().get_size().y)
                rect.set_name("Sprite")
                wall.add_child(rect)