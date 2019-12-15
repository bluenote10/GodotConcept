extends Node2D

func _ready():
    # Create viewport
    var viewport = Viewport.new()
    viewport.size = Vector2(200, 200)
    viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
    
    # Create some test content
    var rect = ColorRect.new()
    rect.color = Color(1, 0, 0)
    rect.rect_size = Vector2(100, 100)
    viewport.add_child(rect)
    
    var text = Label.new()
    text.text = "Hello World"
    viewport.add_child(text)

    #var cam = Camera2D.new()
    #viewport.add_child(cam)
    
    # Add to scene
    #rect.show()
    add_child(viewport)

    # Wait for content
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    
    # Fetch viewport content
    var texture = viewport.get_texture()
    var image = texture.get_data()
    image.flip_y()
    image.save_png("test.png")

    print(image.get_width())
    print(image.get_height())
    print("written test.png")
    
    #var im2 = Image.new()
    print(image)
    print(image.get_data())
    var raw = image.get_data()
    var sum = 0
    for x in raw:
        sum += x
    print("Pixel sum: ", sum)
    
    #$TextureRect.texture = texture
    #$TextureRect.texture
    