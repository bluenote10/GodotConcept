extends Area2D

export var speed = 200  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.


func _ready():
    screen_size = get_viewport_rect().size
    
    # Note: Maybe we want to do this: https://docs.godotengine.org/en/3.1/tutorials/inputs/custom_mouse_cursor.html
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
    # Mouse in viewport coordinates
    if event is InputEventMouseButton:
        print("Mouse Click/Unclick at: ", event.position)
    elif event is InputEventMouseMotion:
        print("Mouse Motion at: ", event.relative)
        rotation += event.relative.x / 400

    # Print the size of the viewport
    print("Viewport Resolution is: ", get_viewport_rect().size)
    

func _physics_process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
    #$AnimatedSprite.play()
    #$AnimatedSprite.stop()

    print(position)
    print(transform)
    position += velocity.rotated(rotation) * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)    
