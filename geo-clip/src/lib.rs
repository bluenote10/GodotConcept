//extern crate geo;

use geo::{polygon};
use geo::Coordinate;

pub struct Segment<T>
where
    T: num_traits::Float
{
    pub p1: Coordinate<T>,
    pub p2: Coordinate<T>,
}


pub fn test() {
    let poly = polygon![
        (x:   0., y:   0.),
        (x: 100., y:   0.),
        (x: 100., y:  10.),
        (x:   0., y:  10.),
    ];
}