extends Node
class_name Utils


static func render_scene_to_texture(node, viewport_size, node_position, scale, scene_path):
    # Create viewport
    var viewport = Viewport.new()
    viewport.size = viewport_size
    viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
    viewport.render_target_v_flip = true
    viewport.transparent_bg = true
   
    # Add scene
    var packed_scene = load("res://scenes/CharacterTexture.tscn")
    var scene = packed_scene.instance()
    scene.position = node_position
    scene.scale = Vector2(scale, scale)
    viewport.add_child(scene)
    
    # Add to scene
    node.add_child(viewport)

    return viewport
    

static func linspace(from, upto, num_points):
    if num_points == 0:
        return []
    elif num_points == 1:
        return [(upto + from) / 2]
    elif num_points == 2:
        return [from, upto]
    elif num_points == 3:
        return [from, (upto + from) / 2, upto]
    else:
        var delta = upto - from
        var array = []
        for i in num_points:
            var value = from + (i / (num_points - 1)) * delta
            array.append(value)
        return array