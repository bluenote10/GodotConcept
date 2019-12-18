extends Node2D

func render_scene_to_texture(viewport_size, node_position, scene_path):
    # Create viewport
    var viewport = Viewport.new()
    viewport.size = Vector2(40, 40)
    viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
    viewport.render_target_v_flip = true
    
    # Add scene
    var packed_scene = load("res://CharacterTexture.tscn")
    var scene = packed_scene.instance()
    scene.position = Vector2(18, 18)
    viewport.add_child(scene)
    
    # Add to scene
    add_child(viewport)

    return viewport


func _ready_old():
    # Create viewport
    var viewport = Viewport.new()
    viewport.size = Vector2(40, 40)
    viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
    viewport.render_target_v_flip = true
    
    # Add scene
    var packed_scene = load("res://CharacterTexture.tscn")
    var scene = packed_scene.instance()
    scene.position = Vector2(18, 18)
    viewport.add_child(scene)
    
    # Add to scene
    add_child(viewport)

    # Wait for content
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    
    # Fetch viewport content
    var texture = viewport.get_texture()
    var image = texture.get_data()
    image.save_png("test.png")

    print(image.get_width())
    print(image.get_height())
    print("written test.png")
   
    $TextureRect.texture = texture
    
    
func _ready():
    var viewport = render_scene_to_texture(Vector2(40, 40), Vector2(18, 18), "res://CharacterTexture.tscn")

    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    
    # Extract texture from viewport
    var texture = ImageTexture.new()
    texture.create_from_image(viewport.get_texture().get_data())
    viewport.queue_free()
    
    # Fetch viewport content
    var image = texture.get_data()
    image.save_png("test.png")

    print(image.get_width())
    print(image.get_height())
    print("written test.png")

    $TextureRect.texture = texture
    
