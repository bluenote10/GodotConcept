use geo::Coordinate;

use num_traits::Float;


#[derive(Copy, Clone, Debug)]
pub struct Epsilon<T>
where
    T: Float
{
    pub eps: T,
}


impl<T> Epsilon<T> where T: Float {
    pub fn new() -> Epsilon<T> {
        let default = T::from(0.0000000001).unwrap(); // That's default in polybooljs. TODO: refine for f32.
        Epsilon::new_with_epsilon(default)
    }

    pub fn new_with_epsilon(eps: T) -> Epsilon<T> {
        assert!(eps > T::from(0).unwrap());
        Epsilon{eps: eps}
    }

    pub fn point_above_or_on_line(&self, p: &Coordinate<T>, a: &Coordinate<T>, b: &Coordinate<T>) -> bool {
        return (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x) >= -self.eps;
    }

    pub fn point_between(&self, p: &Coordinate<T>, a: &Coordinate<T>, b: &Coordinate<T>) -> bool {
        // p must be collinear with a->b
        // returns false if p == a, p == b, or a == b
        let d_py_ly = p.y - a.y;
        let d_rx_lx = b.x - a.x;
        let d_px_lx = p.x - a.x;
        let d_ry_ly = b.y - a.y;

        let dot = d_px_lx * d_rx_lx + d_py_ly * d_ry_ly;
        // if `dot` is 0, then `p` == `a` or `a` == `b` (reject)
        // if `dot` is less than 0, then `p` is to the a of `a` (reject)
        if dot < self.eps {
            return false;
        }

        let sqlen = d_rx_lx * d_rx_lx + d_ry_ly * d_ry_ly;
        // if `dot` > `sqlen`, then `p` is to the b of `b` (reject)
        // therefore, if `dot - sqlen` is greater than 0, then `p` is to the b of `b` (reject)
        if dot - sqlen > -self.eps {
            return false;
        }

        return true;
    }

    pub fn points_same_x(&self, a: &Coordinate<T>, b: &Coordinate<T>) -> bool {
        return (a.x - b.x).abs() < self.eps;
    }

    pub fn points_same_y(&self, a: &Coordinate<T>, b: &Coordinate<T>) -> bool {
        return (a.y - b.y).abs() < self.eps;
    }

    pub fn points_same(&self, a: &Coordinate<T>, b: &Coordinate<T>) -> bool {
        return self.points_same_x(&a, &b) && self.points_same_y(&a, &b);
    }

    pub fn points_compare(&self, a: &Coordinate<T>, b: &Coordinate<T>) -> i8 {
        // returns -1 if `a` is smaller, 1 if `b` is smaller, 0 if equal
        if self.points_same_x(a, b) {
            if self.points_same_y(a, b) { 0 } else {
                 if a.y < b.y { -1 } else  { 1 }
            }
        } else {
            if a.x < b.x { -1 } else { 1 }
        }
    }

    pub fn points_collinear(&self, a: &Coordinate<T>, b: &Coordinate<T>, c: &Coordinate<T>) -> bool {
        // does a->b->c make a straight line?
        // essentially this is just checking to see if the slope(a->b) === slope(b->c)
        // if slopes are equal, then they must be collinear, because they share b
        let dx1 = a.x - b.x;
        let dy1 = a.y - b.y;
        let dx2 = b.x - c.x;
        let dy2 = b.y - c.y;
        return (dx1 * dy2 - dx2 * dy1).abs() < self.eps;
    }

    pub fn lines_intersect(&self, a0: &Coordinate<T>, a1: &Coordinate<T>, b0: &Coordinate<T>, b1: &Coordinate<T>) -> Option<LineIntersection<T>> {
        // returns false if the lines are coincident (e.g., parallel or on top of each other)
        //
        // returns an object if the lines intersect:
        //   {
        //     p: Coordinate
        //     along_a: where intersection point is along A,
        //     along_b: where intersection point is along B
        //   }
        //
        //  along_a and along_b will each be one of: -2, -1, 0, 1, 2
        //
        //  with the following meaning:
        //
        //    -2   intersection point is before segment's first point
        //    -1   intersection point is directly on segment's first point
        //     0   intersection point is between segment's first and second points (exclusive)
        //     1   intersection point is directly on segment's second point
        //     2   intersection point is after segment's second point
        let adx = a1.x - a0.x;
        let ady = a1.y - a0.y;
        let bdx = b1.x - b0.x;
        let bdy = b1.y - b0.y;

        let axb = adx * bdy - ady * bdx;
        if axb.abs() < self.eps {
            return None; // lines are coincident
        }

        let dx = a0.x - b0.x;
        let dy = a0.y - b0.y;

        let A = (bdx * dy - bdy * dx) / axb;
        let B = (adx * dy - ady * dx) / axb;

        let mut ret = LineIntersection{
            p: Coordinate{
                x: a0.x + A * adx,
                y: a0.y + A * ady,
            },
            along_a: 0,
            along_b: 0,
        };

        // categorize where intersection point is along A and B
        let one = T::from(1).unwrap(); // TODO: check if that is nicest solution

        if A <= -self.eps {
            ret.along_a = -2;
        } else if A < self.eps {
            ret.along_a = -1;
        } else if A - one <= -self.eps {
            ret.along_a = 0;
        } else if A - one < self.eps {
            ret.along_a = 1;
        } else {
            ret.along_a = 2;
        }

        if B <= -self.eps {
            ret.along_b = -2;
        } else if B < self.eps {
            ret.along_b = -1;
        } else if B - one <= -self.eps {
            ret.along_b = 0;
        } else if B - one < self.eps {
            ret.along_b = 1;
        } else {
            ret.along_b = 2;
        }

        return Some(ret);
    }

    // TODO: Wait with implementation until we know what type `region` will have:
    // pub fn point_inside_region(&self, a0: &Coordinate<T>, region: ...) -> bool {}

}


#[derive(Copy, Clone, Debug)]
pub struct LineIntersection<T>
where
    T: Float
{
    pub p: Coordinate<T>,
    pub along_a: i8,
    pub along_b: i8,
}

