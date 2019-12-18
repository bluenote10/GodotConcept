extends Node2D

func draw_circle_line_arc(center, radius, angle_from, angle_to, color, width=1.0):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        #draw_line(points_arc[index_point], points_arc[index_point + 1], color, true)
        draw_line_antialiased(points_arc[index_point], points_arc[index_point + 1], color, width)


func draw_circle_line(center, radius, color, width=1.0):
    draw_circle_line_arc(center, radius, 0, 360, color, width)
     
    
func draw_line_antialiased(p1, p2, color=Color(1.0, 1.0, 1.0, 1.0), width=1.0):
    var center = 0.5 * (p1 + p2)
    var delta = p2 - p1
    var rotation = atan2(delta.x, delta.y)
    
    var transform = Transform2D()
    # Subtract half a pixel ensures that the texture aligns with physical pixels
    transform *= Transform2D().translated(center - Vector2(0.5, 0.5))
    transform *= Transform2D().rotated(-rotation)
    transform *= Transform2D().scaled(Vector2(width, delta.length()))
    
    draw_set_transform_matrix(transform)
    # The texture has a 3x1 resolution, subtracting by half, because the above
    # transforms to the drawing center (not upper left coordinate as it would 
    # be with (0, 0)).
    draw_texture(imageTexture, Vector2(-1.5, -0.5), color)
    
    # Some test drawing code for the record
    """
    draw_line(Vector2(10, 10), Vector2(15, 20), Color(1, 0, 0))
    draw_line_antialiased(Vector2(10, 10), Vector2(20, 20))
    
    var width = 4.0
    draw_line_antialiased(Vector2(10, 10), Vector2(10, 20), Color(1, 0, 0), width)
    draw_line_antialiased(Vector2(10, 10), Vector2(20, 10), Color(1, 0, 0), width)
    draw_line_antialiased(Vector2(10, 10), Vector2(10, 0), Color(1, 0, 0), width)
    draw_line_antialiased(Vector2(10, 10), Vector2(0, 10), Color(1, 0, 0), width)

    draw_line_antialiased(Vector2(30, 40), Vector2(50, 40), Color(1, 0, 0), width)
    draw_line_antialiased(Vector2(40, 30), Vector2(40, 50), Color(1, 0, 0), width)
    """
    
       
var image: Image
var imageTexture: ImageTexture    
export var radius = 16.0
  
func _ready():
    image = Image.new()
    image.create(3, 1, false, Image.FORMAT_RGBA8)
    image.lock()
    image.set_pixel(0, 0, Color(0, 0, 0, 0))
    image.set_pixel(1, 0, Color(1, 1, 1, 1))
    image.set_pixel(2, 0, Color(0, 0, 0, 0))
    image.unlock()

    imageTexture = ImageTexture.new()
    imageTexture.create(3, 1, image.get_format(), ImageTexture.FLAG_FILTER | ImageTexture.FLAG_ANISOTROPIC_FILTER)    
    imageTexture.set_data(image)

    # Precise adjustment of label rendering position
    var label = $Label
    var label_size = label.rect_size
    label.rect_position = Vector2(
        -label_size.x / 2 - 0.5, 
        -label_size.y / 2 - 1.5
    )


func _draw():
    var center := Vector2(0, 0)
    draw_circle(center, radius, Color(0.13, 0.13, 0.13))
    draw_circle_line(center, radius, Color(0.05, 0.05, 0.05))
  
