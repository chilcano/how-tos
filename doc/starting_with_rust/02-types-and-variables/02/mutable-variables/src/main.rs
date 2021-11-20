#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]
#![allow(unused_assignments)]

use std::fmt;

fn type_of<T>(_: &T) {
    println!("* The variable is of type {}", std::any::type_name::<T>());
}

fn name_and_type_of<T>(var: &str, _: &T) {
    println!("- The {:?} is of type {:?}", var, std::any::type_name::<T>());
}

fn main() {
    let number = 3;
    let firstname = "Super";

    // mutable
    let mut account_balance = 1000;
    account_balance = 200;

    // shadowing
    let surname = "Man";
    let surname = "Raton";

    const PI:f32 = 3.14;

    // printing variable type
    type_of(&number);
    type_of(&firstname);

    // printing variable name and type
    name_and_type_of(&"account_balance", &account_balance);
    name_and_type_of(&"surname", &surname);
}