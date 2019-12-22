#[macro_use]
extern crate gdnative as godot;
extern crate rand;

use godot::GodotString;
use godot::NodePath;
use godot::Vector2;
use rand::Rng;

#[inherit(godot::Node)]
#[derive(godot::NativeClass)]
#[user_data(godot::user_data::ArcData<World>)]
struct World;

#[godot::methods]
impl World {

    fn _init(_owner: godot::Node) -> Self {
        World{}
    }

    #[export]
    fn _ready(&self, mut owner: godot::Node) {
        godot_print!("Hello world.");
    }

    #[export]
    fn _process(&self, mut owner: godot::Node, delta: f64) {
    }

}

fn init(handle: gdnative::init::InitHandle) {
    handle.add_class::<World>();
}

godot_gdnative_init!();
godot_nativescript_init!(init);
godot_gdnative_terminate!();
