extends KinematicBody2D

export var max_speed = 100
export var acceleration = 1000
export var melee_margin: float = 80

var enemy_radius = 16

var debug_visibility: bool = false
var debug_visibility_points: PoolVector2Array = []


func _ready():
    # Possibly needed if we need in-pause enemy processing
    # pause_mode = Node.PAUSE_MODE_PROCESS
    
    var scale_fraction = enemy_radius / $CollisionShape2D.shape.radius
    # print("Scaling enemy to radius %f with scale %f" % [enemy_radius, scale_fraction])
    scale = Vector2(scale_fraction, scale_fraction)

    # Start invisible -- visibility is handled in _process_physics
    visible = false


func _physics_process(delta_time):
    # If using in-pause enemy processing, we could simply skip computing
    # movement here like that:
    # if get_tree().paused:
    #     return

    var players = get_tree().get_nodes_in_group("player")
    if players.size() != 1:
        push_warning("Expected to find a single player")
    
    else:
        # First compute primary target (player)
        var target = players[0].position
        handle_movement(target, delta_time)
        handle_visibility(target, players[0])


func handle_movement(target, delta_time):

    var delta = target - position
    
    # Apply margin to target
    target = target - delta.normalized() * melee_margin
    delta = target - position
    
    # To account for overshooting, we need to feed move_and_slide with
    # a velocity that incorporates the frame duration. Simply compute
    # via v = s / t.
    var required_velocity = (delta.length() / delta_time)
    required_velocity = clamp(required_velocity, -max_speed, max_speed)

    delta = delta.normalized() * required_velocity

    var actual_velocity = move_and_slide(delta)


func handle_visibility(target, player):
    # Note this must only be called from _process_physics for space state access
    var space_state = get_world_2d().direct_space_state
    
    var delta = target - position
    var distance = delta.length()
    
    # TODO: incorporate player visibility here
    if distance > 1000:
        visible = false
    else:
        var radial_normal = Vector2(delta.y, -delta.x).normalized()
        var test_points = [
            position - radial_normal * enemy_radius * 0.9,
            position,
            position + radial_normal * enemy_radius * 0.9,
        ]

        # Temporarily switch to the "walls only" collision layer so that only walls
        # and the current enemy are visible for the player (and other enemies don't
        # occlude the view).
        # But super weird, we have to adjust the layer, not the mask, big surprise in general:
        # https://godotengine.org/qa/3020/collision-masks-and-its-propper-uses
        var old_collision_layer = self.collision_layer
        self.collision_layer = 2
    
        var result = null
        for test_point in test_points:
            result = space_state.intersect_ray(target, test_point, [], 2)
            # Weird somehow we need the result.size() > 0 check here...
            if result != null and result.size() > 0 and result.rid == get_rid():
                break
        self.collision_layer = old_collision_layer

        # print("target: ", target)
        # print("enemy: ", position)
        # print("hit_point: ", result.position)
        # print("hit_point (local): ", to_local(result.position))
        
        if result:
            # print(result)
            # print(get_rid(), " ", result.rid)
            if result.rid == get_rid():
                visible = true
            else:
                visible = false
            
            if debug_visibility:
                debug_visibility_points = [
                    to_local(result.position)
                ]
                # Note it is crucial to enforce a draw update, otherwise the debug
                # drawing never updates...
                update()
        else:
            visible = false
        

func _draw():
    if debug_visibility:
        for debug_point in debug_visibility_points:
            draw_circle(debug_point, 30, Color(1, 0, 0))
 

# Old implementation based on RigidBody2D        
"""
func _integrate_forces(state):

    var players = get_tree().get_nodes_in_group("player")
    if players.size() != 1:
        push_warning("Expected to find a single player")
    
    else:
        var target = players[0].position
        var delta = target - state.transform.get_origin()
        
        print(target, state.transform.get_origin())
        
        delta = delta.normalized() * state.get_step() * acceleration

        state.apply_central_impulse(delta.rotated(rotation))
    
        if state.linear_velocity.length() > max_speed:
            state.set_linear_velocity(state.linear_velocity.normalized() * max_speed)
"""
        