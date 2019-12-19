class_name DamagePointLauncher

const DAMAGE_POINT_SCENE = preload("res://scenes/DamagePoint.tscn")

var lifetime = 0.1

var parent: Node2D = null

var time_sum := 0.0
var finished := false


func init(parent_arg):
    parent = parent_arg
    

func launch_damage_points(t1, t2):
    
    var alpha_from = t1 / lifetime
    var alpha_upto = t2 / lifetime
    
    print(alpha_from, " ", alpha_upto, " ", alpha_upto - alpha_from)
    
    var num_points_ang = 5
    var num_points_rad = 3

    var alphas = Utils.linspace(alpha_from, alpha_upto, num_points_ang)
    var radiuses = Utils.linspace(30, 50, 3)

    var max_angle = deg2rad(120)
    for alpha in alphas:
        alpha = rand_range(alpha_from, alpha_upto)
        var angle = -max_angle + alpha * 2 * max_angle
        for radius in radiuses:
            radius = rand_range(30, 50)
            
            var damage_point = DAMAGE_POINT_SCENE.instance()
            damage_point.transform = \
                Transform2D().rotated(angle) * \
                Transform2D().translated(Vector2(0, -radius))
                
            damage_point.pause_mode = Node.PAUSE_MODE_STOP
            parent.add_child(damage_point)
                

func process_physics(delta):
    
    if time_sum <= lifetime:
        launch_damage_points(time_sum, time_sum + delta)
        time_sum += delta
    else:
        finished = true
        
    """
    var damage_point = DAMAGE_POINT_SCENE.instance()
    damage_point.position = Vector2(0 + rand_range(-10, 10), -20 + rand_range(-10, 10))
    damage_point.pause_mode = Node.PAUSE_MODE_STOP
    parent.add_child(damage_point)
    """
    
