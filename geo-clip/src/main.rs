#![allow(dead_code)]
#![allow(unused_variables)]

extern crate geo_clip;

mod playground;

use geo::{polygon};
use geo_clip::Epsilon;


fn main() {
    //println!("{}", std::usize::MAX);
    //println!("Size is {}", std::mem::size_of::<E1>());

    let poly = polygon![
        (x:   0., y:   0.),
        (x: 100., y:   0.),
        (x: 100., y:  10.),
        (x:   0., y:  10.),
    ];

    let eps = Epsilon::<f64>::new();

    geo_clip::sweep_self(&poly, &eps);
}

