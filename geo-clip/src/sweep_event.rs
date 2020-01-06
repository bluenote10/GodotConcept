use geo_types::Coordinate;
use num_traits::Float;
use std::cell::RefCell;
use std::cmp::Ordering;
use std::rc::{Rc, Weak};

use super::segment::Segment;
use super::epsilon::Epsilon;


#[derive(Clone, Copy, PartialEq, Eq)]
pub enum EdgeType {
    Normal,
    NonContributing,
    SameTransition,
    DifferentTransition,
}

/*
The Nim type has:
   isStart*: bool
   pt*: PointT
   seg*: Edge
   primary*: bool
   other*: LinkedNode[NodeData]
   status*: LinkedNode[NodeData]
*/


#[derive(Clone)]
struct MutablePart<F>
where
    F: Float,
{
    other: Weak<SweepEvent<F>>,
    status: Weak<SweepEvent<F>>,
}


#[derive(Clone)]
pub struct SweepEvent<F>
where
    F: Float,
{
    pub p: Coordinate<F>,
    pub seg: Segment<F>,
    pub is_start: bool,
    pub primary: bool,
    mutable: RefCell<MutablePart<F>>,
    eps: Epsilon<F>,
}


impl<F> SweepEvent<F>
where
    F: Float,
{
    pub fn new_rc(
        p: &Coordinate<F>,
        seg: &Segment<F>,
        eps: Epsilon<F>,
    ) -> Rc<SweepEvent<F>> {
        Rc::new(SweepEvent {
            p: p.clone(),
            seg: seg.clone(),
            is_start: true,
            primary: true,
            mutable: RefCell::new(MutablePart {
                other: Weak::default(),
                status: Weak::default(),
            }),
            eps: eps,
        })
    }

    /*
    pub fn is_left(&self) -> bool {
        self.mutable.borrow().left
    }

    pub fn set_left(&self, left: bool) {
        self.mutable.borrow_mut().left = left
    }

    pub fn get_other_event(&self) -> Option<Rc<SweepEvent<F>>> {
        self.mutable.borrow().other_event.upgrade()
    }

    pub fn set_other_event(&self, other_event: &Rc<SweepEvent<F>>) {
        self.mutable.borrow_mut().other_event = Rc::downgrade(other_event);
    }

    pub fn get_edge_type(&self) -> EdgeType {
        self.mutable.borrow().edge_type
    }

    pub fn set_edge_type(&self, edge_type: EdgeType) {
        self.mutable.borrow_mut().edge_type = edge_type
    }

    pub fn is_in_out(&self) -> bool {
        self.mutable.borrow().in_out
    }

    pub fn is_other_in_out(&self) -> bool {
        self.mutable.borrow().other_in_out
    }

    pub fn is_in_result(&self) -> bool {
        self.mutable.borrow().in_result
    }

    pub fn set_in_result(&self, in_result: bool) {
        self.mutable.borrow_mut().in_result = in_result
    }

    pub fn set_in_out(&self, in_out: bool, other_in_out: bool) {
        let mut mutable = self.mutable.borrow_mut();

        mutable.in_out = in_out;
        mutable.other_in_out = other_in_out;
    }

    pub fn get_pos(&self) -> i32 {
        self.mutable.borrow().pos
    }

    pub fn set_pos(&self, pos: i32) {
        self.mutable.borrow_mut().pos = pos
    }

    pub fn is_below(&self, p: Coordinate<F>) -> bool {
        if let Some(ref other_event) = self.get_other_event() {
            if self.is_left() {
                //signed_area(self.point, other_event.point, p) > F::zero()
                false
            } else {
                //signed_area(other_event.point, self.point, p) > F::zero()
                false
            }
        } else {
            false
        }
    }

    pub fn is_above(&self, p: Coordinate<F>) -> bool {
        !self.is_below(p)
    }

    pub fn is_vertical(&self) -> bool {
        match self.get_other_event() {
            Some(ref other_event) => self.point.x == other_event.point.x,
            None => false,
        }
    }
    */
}

impl<F> PartialEq for SweepEvent<F>
where
    F: Float,
{
    fn eq(&self, other: &Self) -> bool {
        false /*
        self.contour_id == other.contour_id
            && self.is_left() == other.is_left()
            && self.point == other.point
            && self.is_subject == other.is_subject
        */
    }
}

impl<F> Eq for SweepEvent<F> where F: Float {}

impl<F> PartialOrd for SweepEvent<F>
where
    F: Float,
{
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl<F> Ord for SweepEvent<F>
where
    F: Float,
{
    fn cmp(&self, that: &Self) -> Ordering {
        /*
		// compare the selected points first
		var comp = eps.pointsCompare(p1_1, p2_1);
		if (comp !== 0)
			return comp;
		// the selected points are the same

		if (eps.pointsSame(p1_2, p2_2)) // if the non-selected points are the same too...
			return 0; // then the segments are equal

		if (p1_isStart !== p2_isStart) // if one is a start and the other isn't...
			return p1_isStart ? 1 : -1; // favor the one that isn't the start

		// otherwise, we'll have to calculate which one is below the other manually
		return eps.pointAboveOrOnLine(p1_2,
			p2_isStart ? p2_1 : p2_2, // order matters
			p2_isStart ? p2_2 : p2_1
		) ? 1 : -1;
        */
        let comp = self.eps.points_compare(&self.p, &that.p);

        Ordering::Equal // TODO

        /*
        // Ord is exactly the other way round as in the js implementation as BinaryHeap sorts decending
        let p1 = self.point;
        let p2 = other.point;

        if p1.x > p2.x {
            return Ordering::Less;
        }
        if p1.x < p2.x {
            return Ordering::Greater;
        }
        if p1.y > p2.y {
            return Ordering::Less;
        }
        if p1.y < p2.y {
            return Ordering::Greater;
        }

        if self.is_left() != other.is_left() {
            return less_if(self.is_left());
        }

        if let (Some(other1), Some(other2)) = (self.get_other_event(), other.get_other_event()) {
            if signed_area(p1, other1.point, other2.point) != F::zero() {
                return less_if(!self.is_below(other2.point));
            }
        }

        less_if(!self.is_subject && other.is_subject)
        */
    }
}

