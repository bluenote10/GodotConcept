use geo::Coordinate;
use num_traits::Float;


#[derive(Copy, Clone, Debug)]
pub struct Fill {
    pub above: bool,
    pub below: bool,
}


#[derive(Clone, Debug)]
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
