use super::vec2::{Vec2};

use rand::Rng;

//use clipping::CPolygon;

use geo_booleanop::boolean::BooleanOp;
use geo::{line_string, polygon};


pub type Polygon = geo::Polygon<f32>;
pub type MultiPolygon = geo::MultiPolygon<f32>;


pub struct Room {
    x_from: f32,
    x_upto: f32,
    y_from: f32,
    y_upto: f32,
}

impl Room {

    pub fn center(&self) -> Vec2 {
        Vec2 {
            x: (self.x_from + self.x_upto) / 2.,
            y: (self.y_from + self.y_upto) / 2.,
        }
    }
}


pub fn generate_rooms(num_to_create: i32) -> Vec<Room> {
    (0 .. num_to_create).map(|_| {
        let mut rng = rand::thread_rng();
        let x = rng.gen_range(-1000., 1000.);
        let y = rng.gen_range(-1000., 1000.);
        let w = rng.gen_range(100., 500.);
        let h = rng.gen_range(100., 500.);
        Room {
            x_from: x - w,
            x_upto: w + x,
            y_from: y - h,
            y_upto: y + h,
        }
    }).collect()
}


pub fn create_polygon_line_like(from: &Vec2, upto: &Vec2, width: f32) -> Polygon {
    let delta = upto - from;
    let normal = delta.perpendicular().normalized();

    let poly = geo::Polygon::new(
        geo::LineString(vec![
            (from - &(&normal * width)).as_coordinate(),
            (from + &(&normal * width)).as_coordinate(),
            (upto + &(&normal * width)).as_coordinate(),
            (upto - &(&normal * width)).as_coordinate(),
        ]),
        vec![],
    );
    poly
}

pub fn connect_rooms(rooms: &[Room]) -> MultiPolygon {
    let mut hallways = geo::MultiPolygon::<f32>(vec![]);
    for i in 0 .. rooms.len() {
        let mut min_distance = std::f32::MAX;
        let mut min_j = 0;
        for j in i+1 .. rooms.len() {
            let center_i = rooms[i].center();
            let center_j = rooms[j].center();
            let distance = ((center_i.x - center_j.x).powf(2.0) + (center_i.y - center_j.y).powf(2.0)).sqrt();
            if distance < min_distance {
                min_distance = distance;
                min_j = j;
            }
        }
        let center_i = rooms[i].center();
        let center_j = rooms[min_j].center();
        let poly = create_polygon_line_like(&center_i, &center_j, 30.);

        hallways = hallways.union(&poly);
    }
    hallways
}


pub fn generate_floor() -> geo::MultiPolygon<f32> {
    godot_print!("Generating floor...");

    let rooms = generate_rooms(5);
    let hallways = connect_rooms(&rooms);

    //let mut joined = CPolygon::new();
    //let mut joined = polygon![]; // geo::Polygon::new();

    let mut joined = hallways; // geo::MultiPolygon::<f32>(vec![]);

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