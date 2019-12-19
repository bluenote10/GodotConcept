extends Area2D


func _ready():
    $Particles2D.lifetime = 1.0
    $Particles2D.emitting = true
    
    
func _process(delta):
    if not $Particles2D.emitting:
        queue_free()