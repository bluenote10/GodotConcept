extends RigidBody2D

export var max_speed = 100
export var acceleration = 1000


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
