extends Area2D

export var speed = 200  # How fast the player will move (pixels/sec).
export var zoom_speed = 1.1
export var camera_offset = 200

var screen_size  # Size of the game window.


func set_camera(camera, zoom):
    camera.zoom.x = zoom
    camera.zoom.y = zoom
    camera.position.y = - zoom * camera_offset

func _ready():
    screen_size = get_viewport_rect().size
    
    # Note: Maybe we want to do this: https://docs.godotengine.org/en/3.1/tutorials/inputs/custom_mouse_cursor.html
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    set_camera($Camera2D, 1.0)


func _input(event):
    if event is InputEventMouseButton:
        print("Mouse Click/Unclick at: ", event.position)

        # Mouse wheel events are also passed in as mouse button events
        if event.is_pressed():
            var camera = $Camera2D
            var zoom = camera.zoom.x
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoom *= zoom_speed
            if event.button_index == BUTTON_WHEEL_UP:
                zoom *= 1.0 / zoom_speed
            
            set_camera(camera, zoom)
            
            $CrosshairLine.width = zoom
            print(zoom)

    elif event is InputEventMouseMotion:
        var mouse_mode := Input.get_mouse_mode()
        if mouse_mode == Input.MOUSE_MODE_CAPTURED:
            rotation += event.relative.x / 400
    

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

    position += velocity.rotated(rotation) * delta
