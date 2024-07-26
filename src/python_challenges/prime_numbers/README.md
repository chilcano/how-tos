# Get Prime Numbers in a range in Python

__1. prime_numbers_1_simple.py__

* Simple

__2. prime_numbers_2_half.py__

* Reduces to half total of divisors

__3. prime_numbers_3_sqrt_plus.py__

* Reduces to SQRT total of divisors

__4. prime_numbers_4_sqrt_plus.py__

* Reduces to SQRT total of divisors and multiple of 2

```sh
$ python prime_numbers_4_sqrt_plus.py 9154 9457109
=> Prime numbers between ( 9154 , 9457109 ) => 629787 prime numbers found.
=> Time elapsed 0:00:17.672512
```

__5. prime_numbers_5_sieve_of_eratosthenes.py__


* Reduces to SQRT total of divisors and all multiple of 2, 3, 5 and other prime.
* Follow Sieve of Eratosthenes method.
* Reference: https://www.geeksforgeeks.org/analysis-different-methods-find-prime-number-python/

```sh
$ python prime_numbers_5_sieve_of_eratosthenes.py 9154 945710987
=> Prime numbers between ( 9154 , 945710987 ) => 48222722 prime numbers found.
=> Time elapsed 0:01:11.728698
```
