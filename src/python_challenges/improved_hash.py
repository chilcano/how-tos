import sys

def improved_hash(input_string, table_size, mod_factor):
    """
    Improved hash function using character positions and a prime multiplier.
    
    Parameters:
    input_string (str): The input string to hash.
    table_size (int): The size of the hash table (modulus).
    
    Returns:
    int: The hash value of the input string.
    """
    # Prime number used as a multiplier
    mod_factor = 31
    hash_value = 0
    
    # Incorporate character positions and use a prime multiplier
    for char in enumerate(input_string):
        hash_value = (hash_value * mod_factor + ord(char)) % table_size
    return hash_value

if __name__ == "__main__":
    prime_multiplier = 31
    input_string = sys.argv[1]
    table_size = int(sys.argv[2])
    hash_value = improved_hash(input_string, table_size, prime_multiplier)
    print(f"The hash value for '{input_string}' is '{hash_value}' (mod={prime_multiplier})")