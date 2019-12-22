
use rand::Rng;

use clipping::CPolygon;
use geo_booleanop::boolean::BooleanOp;
use geo::{line_string, polygon};


pub struct Vec2 {
    x: f32,
    y: f32,
}


pub struct Room {
    x_from: f32,
    x_upto: f32,
    y_from: f32,
    y_upto: f32,
}

impl Room {

    pub fn center(&self) -> Vec2 {
        Vec2 {
            x: (self.x_from + self.x_upto) / 2f32,
            y: (self.y_from + self.y_upto) / 2f32,
        }
    }
}


pub fn generate_rooms(num_to_create: i32) -> Vec<Room> {
    (0 .. num_to_create).map(|_| {
        let mut rng = rand::thread_rng();
        let x = rng.gen_range(-1000_f32, 1000_f32);
        let y = rng.gen_range(-1000_f32, 1000_f32);
        let w = rng.gen_range(100_f32, 500_f32);
        let h = rng.gen_range(100_f32, 500_f32);
        Room {
            x_from: x - w,
            x_upto: w + x,
            y_from: y - h,
            y_upto: y + h,
        }
    }).collect()
}


pub fn generate_floor() -> geo::MultiPolygon<f32> {
    godot_print!("Generating floor...");

    let rooms = generate_rooms(3);

    //let mut joined = CPolygon::new();
    //let mut joined = polygon![]; // geo::Polygon::new();

    let mut joined = geo::MultiPolygon::<f32>(vec![]);

    for room in rooms {
        let poly = polygon![
            (x: room.x_from, y: room.y_from),
            (x: room.x_upto, y: room.y_from),
            (x: room.x_upto, y: room.y_upto),
            (x: room.x_from, y: room.y_upto),
        ];

        joined = joined.union(&poly);
    }

    godot_print!("Joined: {:?}", joined);
    joined

    /*
    let mut polygons: geo::MultiPolygon<f32> = rooms.iter().map(|room| {
        let poly = polygon![
            (x: room.x_from, y: room.y_from),
            (x: room.x_upto, y: room.y_from),
            (x: room.x_upto, y: room.y_upto),
            (x: room.x_from, y: room.y_upto),
        ];
        poly

        /*
        let mut room_poly_data = vec![
            [room.x_from as f64, room.y_from as f64],
            [room.x_upto as f64, room.y_from as f64],
            [room.x_upto as f64, room.y_upto as f64],
            [room.x_from as f64, room.y_upto as f64],
        ];

        let room_poly = CPolygon::from_vec(&room_poly_data);
        //joined = joined.union(room_poly);
        */
    }).collect();
    */

    /*
    // two polygons
    let poly_a: Vec<[f64; 2]> = vec![[40., 34.], [200., 66.], [106., 80.], [120., 175.]];
    let poly_b = vec![[133., 120.], [80., 146.], [26., 106.], [40., 90.], [0., 53.], [80., 66.], [146., 0.]];

    // Get the clipping polygons
    let mut cp_a = CPolygon::from_vec(&poly_a);
    let mut cp_b = CPolygon::from_vec(&poly_b);

    // clip operation (intersection, union, difference)
    let cp_ab = cp_a.intersection(&mut cp_b);

    // handle the new polygons
    for poly_c in cp_ab{
        godot_print!("Cliped polygon : {:?}", poly_c);
    }
    */

}