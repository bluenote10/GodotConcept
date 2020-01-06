#![allow(dead_code)]
#![allow(unused_variables)]

//extern crate geo;

use geo::Coordinate;
use geo::Polygon;

use num_traits::Float;

mod epsilon;

pub use epsilon::Epsilon;


#[derive(Copy, Clone, Debug)]
pub struct Fill {
    pub above: bool,
    pub below: bool,
}


#[derive(Debug)]
pub struct Segment<T>
where
    T: Float
{
    pub id: usize,
    pub p_from: Coordinate<T>,
    pub p_upto: Coordinate<T>,
    pub this_fill: Fill,
    pub that_fill: Fill,
}

impl<T> Segment<T> where T: Float {
    pub fn new(p_from: Coordinate<T>, p_upto: Coordinate<T>) -> Segment<T> {
        Segment{
            id: 0,
            p_from: p_from,
            p_upto: p_upto,
            this_fill: Fill{above: false, below: true},
            that_fill: Fill{above: false, below: true},
        }
    }

    pub fn copy(original: &Segment<T>) -> Segment<T> {
        Segment{
            id: original.id,
            p_from: original.p_from,
            p_upto: original.p_upto,
            this_fill: original.this_fill,
            that_fill: Fill{above: false, below: true},
        }
    }
}


pub fn sweep<T>(self_sweep: bool, eps: &Epsilon<T>)
where
    T: Float
{

}


pub fn sweep_self<T>(poly: &Polygon<T>, eps: &Epsilon<T>)
where
    T: Float
{

}


pub fn sweep_pair<T>(eps: &Epsilon<T>)
where
    T: Float
{

}

