tool
extends MeshInstance2D


func build_triangles(points):
    var vertices = PoolVector2Array()
    var normals = PoolVector2Array()
    
    for i in points.size():
        var j = i + 1
        if j >= points.size():
            j = 0

        var p1 = points[i]
        var p2 = points[j]

        var d = p2 - p1
        var n = Vector2(d.y, -d.x).normalized()

        # print(p1, p2, d, n)

        # triangle 1
        vertices.push_back(p1)
        vertices.push_back(p2)
        vertices.push_back(p1)
        normals.push_back(n * 2)
        normals.push_back(n * 2)
        normals.push_back(-n)

        # triangle 2
        vertices.push_back(p1)
        vertices.push_back(p2)
        vertices.push_back(p2)
        normals.push_back(-n)
        normals.push_back(n * 2)
        normals.push_back(-n)
        
    
    return {
        vertices=vertices, 
        normals=normals,
    }


func _ready():

    var points = PoolVector2Array()
    points.push_back(Vector2(0, 0))
    points.push_back(Vector2(100, 0))
    points.push_back(Vector2(100, 100))
    points.push_back(Vector2(0, 200))


    var triangles = build_triangles(points)
    
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = triangles.vertices
    arrays[ArrayMesh.ARRAY_TEX_UV] = triangles.normals
    
    # Create the Mesh.
    var mesh = ArrayMesh.new()
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    
    #mesh = arr_mesh

    set_mesh(mesh)
