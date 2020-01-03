use geo::{line_string, polygon};
use geo::MultiPolygon;

use godot::Vector2;
use godot::Variant;
use godot::Dictionary;

use std::fs::File;
use std::io::Write;
use serde::{Deserialize, Serialize};
use serde_json::Result;


pub fn convert<T>(polygons: &MultiPolygon<T>) -> godot::VariantArray
where
    T: geo::CoordinateType,
    T: serde::Serialize,
    f32: std::convert::From<T> {

    // Debug output generation
    let f = File::create("world.json").expect("Unable to create debug JSON file.");
    serde_json::to_writer_pretty(f, &polygons).unwrap();

    let mut array = gdnative::VariantArray::new();

    godot_print!("Number of polygons: {}", polygons.0.len());

    for polygon in polygons.clone().into_iter() {
        godot_print!("Number of holes: {}", polygon.interiors().len());

        //let mut exterior_interior = godot::VariantArray::new();
        let mut out_poly = Dictionary::new();

        let mut data = godot::Vector2Array::new();
        for point in polygon.exterior().clone().into_iter() {
            let vector = Vector2::new(f32::from(point.x), f32::from(point.y));
            data.push(&vector);
        }
        //exterior_interior.push(&Variant::from_vector2_array(&data));
        out_poly.set(&Variant::from_str("exterior"), &Variant::from_vector2_array(&data));

        let mut data = godot::Vector2Array::new();
        for line_string in polygon.interiors().clone().into_iter() {
            for point in line_string.clone().into_iter() {
                let vector = Vector2::new(f32::from(point.x), f32::from(point.y));
                data.push(&vector);
            }
        }
        //exterior_interior.push(&Variant::from_vector2_array(&data));
        out_poly.set(&Variant::from_str("interiors"), &Variant::from_vector2_array(&data));

        //array.push(&Variant::from_array(&exterior_interior));
        array.push(&Variant::from_dictionary(&out_poly));
    }

    array
}
