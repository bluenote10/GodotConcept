extends RigidBody2D

export var max_speed = 200
export var acceleration = 10000

export var zoom_speed = 1.1
export var camera_offset = 200

var screen_size  # Size of the game window.
var mouse_delta := Vector2(0, 0)


func set_camera(camera, zoom):
    camera.zoom.x = zoom
    camera.zoom.y = zoom
    camera.position.y = - zoom * camera_offset


func _ready():
    # Exclude player from pause mode
    # Maybe we need this instead (if enemies also need processing, and just Physics should shut down?):
    # https://godotengine.org/qa/31777/pause-scene-but-have-process-mode-nodes-still-process-physics?show=31783#a31783
    pause_mode = Node.PAUSE_MODE_PROCESS

    screen_size = get_viewport_rect().size
    
    # Note: Maybe we want to do this: https://docs.godotengine.org/en/3.1/tutorials/inputs/custom_mouse_cursor.html
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    set_camera($Camera2D, 1.0)

    var viewport = Utils.render_scene_to_texture(
        self, Vector2(80, 80), Vector2(40, 40), 2.1, "res://CharacterTexture.tscn")
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    # Extract texture from viewport
    var texture = ImageTexture.new()
    texture.create_from_image(viewport.get_texture().get_data())
    viewport.queue_free()

    $Sprite.texture = texture
    $Sprite.scale = Vector2(0.4, 0.4)


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
            #rotation += event.relative.x / 400
            mouse_delta += event.relative
   
func _integrate_forces(state):
    var delta = Vector2()
    if Input.is_action_pressed("ui_right"):
        delta.x += 1
    if Input.is_action_pressed("ui_left"):
        delta.x -= 1
    if Input.is_action_pressed("ui_down"):
        delta.y += 1
    if Input.is_action_pressed("ui_up"):
        delta.y -= 1
    
    if delta.length() > 0:
        delta = delta.normalized() * state.get_step() * acceleration

    #velocity = move_and_slide(velocity.rotated(rotation))
    #state.set_linear_velocity(velocity.rotated(rotation))
    if delta.length() > 0:
        state.apply_central_impulse(delta.rotated(rotation))
    
        if state.linear_velocity.length() > max_speed:
            state.set_linear_velocity(state.linear_velocity.normalized() * max_speed)
    
    else:
        state.set_linear_velocity(state.linear_velocity / 2)
         


func _physics_process(delta):
    """
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

    #position += velocity.rotated(rotation) * delta
    velocity = move_and_slide(velocity.rotated(rotation))
    """
    
    var any_keypress = \
        Input.is_action_pressed("ui_right") or \
        Input.is_action_pressed("ui_left") or \
        Input.is_action_pressed("ui_down") or \
        Input.is_action_pressed("ui_up") or \
        Input.is_action_pressed("ui_wait") or \
        Input.is_mouse_button_pressed(0) or \
        Input.is_mouse_button_pressed(1) or \
        Input.is_mouse_button_pressed(2)
    
    if any_keypress or mouse_delta.length() > 0:
        if get_tree().paused == true:
            print("resuming")
            get_tree().paused = false
    else:
        if get_tree().paused == false:
            print("pausing")
            get_tree().paused = true
    
    #print(Input.get_last_mouse_speed())
    rotation += mouse_delta.x / 400

    mouse_delta = Vector2(0, 0)
