pub fn demo() {
    let temp = 35;

    if temp > 30 {
        // curly braces are mandatory!
        println!("really hot outside!");
    } else if temp < 10 {
        println!("really cold, don't go out!");
    } else {
        println!("temperature is OK");
    }

    // if is an expression!
    let day = if temp > 20 { "sunny" } else { "cloudy" };
    println!("today is {}", day);

    // 20+ hot, <20 cold
    println!(
        "it is {}",
        if temp > 20 {
            "hot"
        } else if temp < 10 {
            "cold"
        } else {
            "OK"
        }
    );

    println!(
        "it is {}",
        if temp > 20 {
            if temp > 30 {
                "very hot"
            } else {
                "hot"
            }
        } else if temp < 10 {
            "cold"
        } else {
            "OK"
        }
    );
}

fn main() {
    demo()
}