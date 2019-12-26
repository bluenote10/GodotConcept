extends RigidBody2D

export var max_speed = 200
export var acceleration = 10000

export var zoom_speed = 1.1
export var camera_offset = 200

const DAMAGE_POINT_SCENE = preload("res://scenes/DamagePoint.tscn")

var DamagePointLauncher = load("res://scenes/DamagePointLauncher.gd")
var damage_point_launcher: DamagePointLauncher = null

var is_first_frame := true

# Input variables accumulated in _input
var mouse_delta := Vector2(0, 0)
var attack_fired := false



func set_camera(camera, zoom):
    camera.zoom.x = zoom
    camera.zoom.y = zoom
    camera.position.y = - zoom * camera_offset

    # TODO: probably this logic need to re-run after resizing?
    var screen_size = get_viewport_rect().size
    
    # Adjust floor to always cover visible area
    # Note: In y-direction, we don't account for the exact y position of the player,
    # just use twice the y resultion, which should always be enough.
    #$FloorRect.rect_position = Vector2(-screen_size.x / 2 * zoom, -screen_size.y * zoom)
    #$FloorRect.rect_size = Vector2(screen_size.x * zoom, screen_size.y * 2 * zoom)


func _ready():
    # Exclude player from pause mode
    # Maybe we need this instead (if enemies also need processing, and just Physics should shut down?):
    # https://godotengine.org/qa/31777/pause-scene-but-have-process-mode-nodes-still-process-physics?show=31783#a31783
    pause_mode = Node.PAUSE_MODE_PROCESS
    
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

        if event.is_pressed() and event.button_index == BUTTON_LEFT:
            attack_fired = true

        # Mouse wheel events are also passed in as mouse button events
        if event.is_pressed() and (event.button_index == BUTTON_WHEEL_DOWN or event.button_index == BUTTON_WHEEL_UP):
            var camera = $Camera2D
            var zoom = camera.zoom.x
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoom *= zoom_speed
            if event.button_index == BUTTON_WHEEL_UP:
                zoom *= 1.0 / zoom_speed
            
            set_camera(camera, zoom)
            
            $CrosshairLine.width = zoom
            print("Zoomed to: ", zoom)

    elif event is InputEventMouseMotion:
        var mouse_mode := Input.get_mouse_mode()
        if mouse_mode == Input.MOUSE_MODE_CAPTURED:
            #rotation += event.relative.x / 400
            mouse_delta += event.relative
   
func _integrate_forces(state):
    var delta = Vector2()
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
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
    
    if (any_keypress or mouse_delta.length() > 0) and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if get_tree().paused == true:
            get_tree().paused = false
    else:
        if is_first_frame:
            # Current work-around to give the enemies one frame to update their visibility.
            is_first_frame = false
        else:
            if get_tree().paused == false:
                get_tree().paused = true
    
    # Handle accumulated mouse delta
    # Note: Input.get_last_mouse_speed() returns really weird results here...
    rotation += mouse_delta.x / 400

    # Handle accumulated triggers
    if attack_fired:
        fire_melee_attack()

    # Process damge point launcher if needed
    if damage_point_launcher != null and not get_tree().paused == true:
        damage_point_launcher.process_physics(delta)

    # Reset accumulated input variables
    mouse_delta = Vector2(0, 0)
    attack_fired = false
    
    
func fire_melee_attack():
    #var damage_point = DAMAGE_POINT_SCENE.instance()
    #damage_point.position = Vector2(0, -10)
    #damage_point.pause_mode = Node.PAUSE_MODE_STOP
    #add_child(damage_point)
    damage_point_launcher = DamagePointLauncher.new()
    damage_point_launcher.init(self)
 
   
func fire_melee_attack_animation():
    var weapon = load("res://scenes/Weapon.tscn").instance()
    add_child(weapon)
    
    var weapon_animation = weapon.get_node("AnimationPlayer")
    weapon_animation.play_backwards("attack")
    
    weapon_animation.connect("animation_finished", self, "weapon_anim_finished", [weapon])
    
    
func weapon_anim_finished(anim_name, weapon_node):
    weapon_node.queue_free()
    
    
    
    
    
    