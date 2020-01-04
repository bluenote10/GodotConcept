extern crate geo;
extern crate geo_booleanop;
extern crate serde;
extern crate serde_json;

use geo_booleanop::boolean::BooleanOp;
use geo::{polygon};
use std::fs::File;


fn main() {

    let polygons = vec![
        polygon![
            (x:   0., y:   0.),
            (x: 100., y:   0.),
            (x: 100., y:  10.),
            (x:   0., y:  10.),
        ],
        polygon![
            (x:  90., y:   0.),
            (x: 100., y:   0.),
            (x: 100., y: 100.),
            (x:  90., y: 100.),
        ],
        polygon![
            (x:   0., y:  90.),
            (x: 100., y:  90.),
            (x: 100., y: 100.),
            (x:   0., y: 100.),
        ],
        polygon![
            (x:   0., y:   0.),
            (x:  10., y:   0.),
            (x:  10., y: 100.),
            (x:   0., y: 100.),
        ],
    ];

    let mut union = geo::MultiPolygon::<f32>(vec![]);
    for poly in &polygons {
        union = union.union(poly);
    }

    let f = File::create("debug_polys_input.json").unwrap();
    serde_json::to_writer_pretty(f, &polygons).unwrap();

    let f = File::create("debug_polys_output.json").unwrap();
    serde_json::to_writer_pretty(f, &union).unwrap();
}