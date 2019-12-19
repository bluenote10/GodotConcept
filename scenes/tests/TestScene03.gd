extends Node2D

const DAMAGE_POINT_SCENE = preload("res://scenes/DamagePoint.tscn")


func _ready():
    #"""
    for i in 1000:
        var damage_point = DAMAGE_POINT_SCENE.instance()
        damage_point.position = Vector2(rand_range(0, 100), rand_range(0, 100))
        damage_point.rotation_degrees = rand_range(0, 360)
        #damage_point.pause_mode = Node.PAUSE_MODE_STOP
        add_child(damage_point)
    #"""
        
func _process(delta):
    """
    for i in 100:
        var damage_point = DAMAGE_POINT_SCENE.instance()
        damage_point.position = Vector2(rand_range(0, 400), rand_range(0, 400))
        damage_point.rotation_degrees = rand_range(0, 360)
        damage_point.pause_mode = Node.PAUSE_MODE_STOP
        add_child(damage_point)
    """
    print(Engine.get_frames_per_second())
