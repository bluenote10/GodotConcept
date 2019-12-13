extends Node2D

func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color, true)
     
    
func draw_line_antialiased(p1, p2):
    var center = 0.5 * (p1 + p2)
    var delta = p2 - p1
    var rotation = atan2(delta.x, delta.y)
    
    var tansform = Transform2D()
    tansform *= Transform2D().translated(center - Vector2(0.5, 0.5))    # subtract half a pixel
    tansform *= Transform2D().rotated(-rotation)
    tansform *= Transform2D().scaled(Vector2(1, delta.length()))
    
    draw_set_transform_matrix(tansform)
    draw_texture(imageTexture, Vector2(-1.5, -0.5))
    
    
       
var image: Image
var imageTexture: ImageTexture    
var i = 0.0
  
func _ready():
    image = Image.new()
    image.create(3, 1, false, Image.FORMAT_RGBA8)
    image.lock()
    image.set_pixel(0, 0, Color(0, 0, 0, 0))
    image.set_pixel(1, 0, Color(0, 0, 255, 255))
    image.set_pixel(2, 0, Color(0, 0, 0, 0))
    image.unlock()
    image.save_png("test.png")

    imageTexture = ImageTexture.new()
    imageTexture.create(3, 1, image.get_format(), ImageTexture.FLAG_FILTER | ImageTexture.FLAG_MIPMAPS | ImageTexture.FLAG_ANISOTROPIC_FILTER)    
    imageTexture.set_data(image)
   
   
func _process(delta):
    update()

func _draw():
    #draw_circle_arc(Vector2(0, 0), 22, 0, 360, Color(255, 0, 0))
    #draw_circle(Vector2(0, 0), 20, Color(255, 0, 0))
    
    #draw_line(Vector2(0, 0), Vector2(100, 200), Color(255, 0, 0), 3.0, true)

    #set_texture(imageTexture)
    #set_process_input(true)
    
    #draw_rect(Rect2(Vector2(), Vector2(1, 1)), Color(0, 255, 0))
    
    #draw_set_transform(Vector2(), 1, Vector2(20, 10))
    #var tansform = Transform2D().scaled(Vector2(1, 10)).rotated(i)
    #draw_set_transform_matrix(tansform)
    #draw_texture(imageTexture, Vector2(0, 0))
    
    draw_line(Vector2(10, 10), Vector2(15, 20), Color(255, 0, 0))
    draw_line_antialiased(Vector2(10, 10), Vector2(20, 20))
    
    draw_line_antialiased(Vector2(10, 10), Vector2(10, 20))
    draw_line_antialiased(Vector2(10, 10), Vector2(20, 10))
    draw_line_antialiased(Vector2(10, 10), Vector2(10, 0))
    draw_line_antialiased(Vector2(10, 10), Vector2(0, 10))
    
    i += 0.1
