use geo::{line_string, polygon};
use geo::MultiPolygon;

use godot::Vector2;
use godot::Variant;

//use gdnative as godot;

pub fn convert<T>(polygons: &MultiPolygon<T>) -> godot::VariantArray
where T: geo::CoordinateType, f32: std::convert::From<T>{

    let mut array = gdnative::VariantArray::new();

    for polygon in polygons.clone().into_iter() {
        let mut exterior_interior = godot::VariantArray::new();

        let mut data = godot::Vector2Array::new();
        for point in polygon.exterior().clone().into_iter() {
            let vector = Vector2::new(f32::from(point.x), f32::from(point.y));
            data.push(&vector);
        }
        exterior_interior.push(&Variant::from_vector2_array(&data));

        let mut data = godot::Vector2Array::new();
        for line_string in polygon.interiors().clone().into_iter() {
            for point in line_string.clone().into_iter() {
                let vector = Vector2::new(f32::from(point.x), f32::from(point.y));
                data.push(&vector);
            }
        }
        exterior_interior.push(&Variant::from_vector2_array(&data));

        array.push(&Variant::from_array(&exterior_interior));
    }

    array
}
