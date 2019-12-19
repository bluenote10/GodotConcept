class_name DamagePointLauncher

const DAMAGE_POINT_SCENE = preload("res://scenes/DamagePoint.tscn")

var lifetime = 1.0

var parent: Node2D = null

var time_sum := 0.0
var finished := false

var num_added = 0

func init(parent_arg):
    parent = parent_arg
    
    

func process_physics(delta):
    
    var alpha_from = time_sum / lifetime
    var alpha_upto = (time_sum + delta) / lifetime
    
    var num_points_ang = 3
    var num_points_rad = 3

    var alphas = Utils.linspace(alpha_from, alpha_upto, num_points_ang)
    var radiuses = Utils.linspace(40, 100, 3)

    var max_angle = 45
    for alpha in alphas:
        var angle = -max_angle + alpha * 2 * max_angle
        #print(angle)
        for radius in radiuses:
            
            var damage_point = DAMAGE_POINT_SCENE.instance()
            damage_point.position = Vector2(0, -radius)
            damage_point.rotation_degrees = angle
            damage_point.pause_mode = Node.PAUSE_MODE_STOP
            #parent.add_child(damage_point)
            num_added += 1
            print(num_added)
                
    time_sum += delta
        
    """
    var damage_point = DAMAGE_POINT_SCENE.instance()
    damage_point.position = Vector2(0 + rand_range(-10, 10), -20 + rand_range(-10, 10))
    damage_point.pause_mode = Node.PAUSE_MODE_STOP
    parent.add_child(damage_point)
    """
    
