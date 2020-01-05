//extern crate geo;

use geo::{polygon};


pub fn test() {
    let poly = polygon![
        (x:   0., y:   0.),
        (x: 100., y:   0.),
        (x: 100., y:  10.),
        (x:   0., y:  10.),
    ];
}