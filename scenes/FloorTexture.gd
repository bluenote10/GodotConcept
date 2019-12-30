extends Sprite

func _process(_delta):
    material.set_shader_param("global_transform", get_global_transform())
    