import sys, time, math
from datetime import timedelta

start_time = time.time()

def get_primes(num_lower, num_upper):
    prime_list = []
    prime = [True for x in range(num_upper+1)]
    prime[0] = prime[1] = False
    max_div = math.floor(math.sqrt(num_upper))        ## gets the sqrt of total divisors
    for divisor in range(2, max_div+1):             ## this reduce to sqrt the total of divisors rather than half of divisors
        if prime[divisor] == True:
            for y in range(divisor*divisor, num_upper+1, divisor):
                prime[y] = False
    for z in range(num_lower, num_upper+1):
        if prime[z]:
            prime_list.append(z)
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

