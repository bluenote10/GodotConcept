extends KinematicBody2D

export var max_speed = 100
export var acceleration = 1000

var enemy_radius = 16


func _ready():
    
    var scale_fraction = enemy_radius / $CollisionShape2D.shape.radius
    print("Scaling enemy to radius %f with scale %f" % [enemy_radius, scale_fraction])
    scale = Vector2(scale_fraction, scale_fraction)
    

func _physics_process(delta_time):

    var players = get_tree().get_nodes_in_group("player")
    if players.size() != 1:
        push_warning("Expected to find a single player")
    
    else:
        var target = players[0].position
        var delta = target - position
        
        print(target, position)
        print(delta.length())
        
        delta = delta.normalized() * max_speed

        move_and_slide(delta)
        

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
        