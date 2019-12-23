extends Node

func set_transform_rect(rect, p1, p2, width=1.0):
    var center = 0.5 * (p1 + p2)
    var delta = p2 - p1
    var rotation = atan2(delta.x, delta.y)
    
    var tansform = Transform2D()
    # Subtract half a pixel ensures that the texture aligns with physical pixels
    rect.rect_position = center
    #rect.rect_rotation = rotation
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


func generate_wall(p1, p2, texture):
    var transform = compute_transform(p1, p2)
    var delta = p2 - p1
    
    var wall = StaticBody2D.new() # Node2D.new()
    wall.transform = transform
    
    # Add sprite
    var rect = Sprite.new()
    rect.texture = texture
    rect.scale = Vector2(1 / texture.get_data().get_size().x, 10 / texture.get_data().get_size().y)
    wall.add_child(rect)

    # Add light occulder
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
    
    return wall
    
    
func generate_walls():
    var texture = load("res://textures/caster.png")

    var num_walls = 100
    
    for i in num_walls:
        
        var p1 = Vector2(rand_range(-1000, 1000), rand_range(-1000, 1000))
        var p2 = Vector2(p1.x + rand_range(-100, 100), p1.y + rand_range(-100, 100))
        #var p1 = Vector2(40, 30)
        #var p2 = Vector2(-100, 200)

        var wall = generate_wall(p1, p2, texture)
        add_child(wall)


func generate_enemies():
    var num_enemies = 20
    
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
    
    var texture = load("res://textures/caster.png")
    
    for polygon in world:
        var exterior = polygon[0]
        var interior = polygon[1] # thats wrong actually...
        
        for i in exterior.size() - 1:
            var p1 = exterior[i]
            var p2 = exterior[i + 1]
            var wall = generate_wall(p1, p2, texture)
            add_child(wall)
            

    #generate_walls()
    generate_enemies()