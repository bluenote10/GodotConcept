#![allow(dead_code)]
#![allow(unused_variables)]

//extern crate geo;

use geo::Polygon;
use num_traits::Float;

mod epsilon;
mod segment;
mod sweep_event;

pub use epsilon::Epsilon;


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

