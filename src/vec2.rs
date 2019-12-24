use std::ops::Add;
use std::ops::Sub;
use std::ops::Mul;
use std::ops::Div;
use std::f32::consts::PI;

use geo::Coordinate;


pub struct Vec2 {
    pub x: f32,
    pub y: f32,
}

// ----------------------------------------------------------------------------
// Vector/Vector operations
// ----------------------------------------------------------------------------

impl Add for &Vec2 {
    fn add(self, that: &Vec2) -> Vec2 {
        Vec2 {
            x: self.x + that.x,
            y: self.y + that.y,
        }
    }
    type Output = Vec2;
}

impl Sub for &Vec2 {
    fn sub(self, that: &Vec2) -> Vec2 {
        Vec2 {
            x: self.x - that.x,
            y: self.y - that.y,
        }
    }
    type Output = Vec2;
}

impl Mul for &Vec2 {
    fn mul(self, that: &Vec2) -> Vec2 {
        Vec2 {
            x: self.x * that.x,
            y: self.y * that.y,
        }
    }
    type Output = Vec2;
}

// ----------------------------------------------------------------------------
// Scalar operations
// ----------------------------------------------------------------------------

impl Add<f32> for &Vec2 {
    fn add(self, scalar: f32) -> Vec2 {
        Vec2 {
            x: self.x + scalar,
            y: self.y + scalar,
        }
    }
    type Output = Vec2;
}

impl Sub<f32> for &Vec2 {
    fn sub(self, scalar: f32) -> Vec2 {
        Vec2 {
            x: self.x - scalar,
            y: self.y - scalar,
        }
    }
    type Output = Vec2;
}

impl Mul<f32> for &Vec2 {
    fn mul(self, scalar: f32) -> Vec2 {
        Vec2 {
            x: self.x * scalar,
            y: self.y * scalar,
        }
    }
    type Output = Vec2;
}

impl Div<f32> for &Vec2 {
    fn div(self, scalar: f32) -> Vec2 {
        Vec2 {
            x: self.x / scalar,
            y: self.y / scalar,
        }
    }
    type Output = Vec2;
}

// ----------------------------------------------------------------------------
// Methods
// ----------------------------------------------------------------------------

impl Vec2 {

    pub fn new(x: f32, y: f32) -> Vec2 {
        Vec2{x: x, y: y}
    }

    pub fn update(&mut self, that: &Vec2) {
        self.x = that.x;
        self.y = that.y;
        // return self?
    }

    pub fn cross_product(&self, that: &Vec2) -> f32 {
        self.x * that.y - self.y * that.x
    }

    pub fn mid(&self, that: &Vec2) -> Vec2 {
        Vec2 {
            x: 0.5 * (self.x + that.x),
            y: 0.5 * (self.y + that.y),
        }
    }

    pub fn length(&self) -> f32 {
        (self.x*self.x + self.y*self.y).sqrt()
    }

    pub fn normalized_with_length(&self, l: f32) -> Vec2 {
        return self * (l / self.length())
    }

    pub fn normalized(&self) -> Vec2 {
        return self / self.length()
    }

    pub fn normalized_in_place(&mut self) {
        let length = self.length();
        self.x = self.x / length;
        self.y = self.y / length;
    }

    pub fn negate(&self) -> Vec2 {
        Vec2 {
            x: -self.x,
            y: -self.y,
        }
    }

    pub fn perpendicular(&self) -> Vec2 {
        Vec2{x: self.y, y: -self.x}
    }

    pub fn as_coordinate(&self) -> Coordinate<f32> {
        Coordinate{x: self.x, y: self.y}
    }
}
