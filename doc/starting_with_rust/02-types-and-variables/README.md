# 02 - Types and Variables

## Resources

* Web: https://www.rust-lang.org/
* Playground: https://play.rust-lang.org/
* https://dev.to/azure/rust-from-the-beginning-variables-3g7c

## 1. Create a program to check the type of immutable variables

### Step 1
Create the program
```sh
$ cd 02-types-and-variables/

$ cargo new 01/check-types --bin
```
### Step 2
Update `01/check-types/src/main.rs` with this code: 
```rust
fn type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>());
}

fn main() {
  let no = 3;
  let name = "Chris";
  type_of(&no);
  type_of(&name);
}
```
### Step 3
Compile and run the program:
```sh
$ cd 01/check-types

$ cargo run

   Compiling check-types v0.1.0 (/home/roger/gitrepos/how-tos/doc/starting_with_rust/02-types-and-variables/01/check-types)
    Finished dev [unoptimized + debuginfo] target(s) in 0.69s
     Running `target/debug/check-types`
i32
&str
```

### Observations
* The `no` and `name` variables are immutable, in other words, Variable values cannot be changed by default.

## 2. Program with mutable variables and constant

### Step 1
Create the program.
```sh
$ cd ../../

$ cargo new 02/mutable-variables --bin
```
### Step 2
Update `01/check-types/src/main.rs` with this code: 
```rust
fn type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>());
}

fn main() {
  let no = 3;
  let name = "Chris";
  type_of(&no);
  type_of(&name);
}
```
### Step 3
Compile and run the program:
```sh
$ cd 02/mutable-variables/

$ cargo run

   Compiling check-types v0.1.0 (/home/roger/gitrepos/how-tos/doc/starting_with_rust/02-types-and-variables/01/check-types)
    Finished dev [unoptimized + debuginfo] target(s) in 0.69s
     Running `target/debug/check-types`
i32
&str
```

### Observations
* The `no` and `name` variables are immutable, in other words, Variable values cannot be changed by default.


