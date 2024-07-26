import sys, time
from datetime import timedelta

start_time = time.time()

def get_primes(num_lower, num_upper):
    prime_list = []
    for num in range(num_lower, num_upper + 1):
        if num > 1:
            for divisor in range(2, num):
                if (num % divisor) == 0:
                    break
            else:       ## 'else' is executed if 'for' has been completed without 'break'
                prime_list.append(num)
    return prime_list

if __name__ == "__main__":
    range_start = int(sys.argv[1])
    range_end = int(sys.argv[2])
    primes = get_primes(range_start, range_end)
    elapsed_time = time.time() - start_time
    if len(primes) == 0:
        primes_msg = "NOT FOUND"
    elif len(primes) < 100:
        primes_msg = primes
    else: 
        primes_msg = str(len(primes)) + " prime numbers found."

    print("=> Prime numbers between (", range_start, ",", range_end, ") =>", primes_msg )
    print("=> Time elapsed", str(timedelta(seconds=elapsed_time)))

