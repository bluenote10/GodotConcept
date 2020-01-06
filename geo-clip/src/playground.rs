
#[derive(Debug, Clone, Copy)]
pub struct PointCloneAndCopy
{
    pub x: f64,
    pub y: f64,
}

#[derive(Debug, Clone)]
pub struct PointCloneOnly
{
    pub x: f64,
    pub y: f64,
}

fn test_copy_and_clone() {
    let p1 = PointCloneAndCopy{x: 0., y: 0.};
    let p2 = p1;    // because type has `Copy`, it gets copied automatically.

    println!("{:?} {:?}", p1, p2);
}

/*
fn test() {
    let p1 = PointCloneAndCopy{x: 0., y: 0.};
    let p2 = &p1;
    let p3: PointCloneAndCopy = *p2;

    println!("{:?} {:?} {:?}", p1, p2, p3);
}
*/
