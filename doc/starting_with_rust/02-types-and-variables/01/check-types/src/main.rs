fn type_of<T>(_: &T) {
    println!("The {} is of type {}", <T>(), std::any::type_name::<T>());
}

fn main() {
  let number = 3;
  let firstname = "Super";

  type_of(&number);
  type_of(&firstname);
}