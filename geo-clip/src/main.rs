
enum E1 {
  above, below
}



fn main() {
  println!("{}", std::usize::MAX);
  println!("Size is {}", std::mem::size_of::<E1>());
}

