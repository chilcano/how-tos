import sys

SIZE = 20       # size hash
FACTOR = 31     # factor to reduce collisions

def simple_hash(ini_str):
    hash_val = 0
    for char in ini_str:
        hash_val = (hash_val * int(FACTOR) + ord(char)) % SIZE
    return hash_val

def reconstruct_data(frag):
    for k, row in frag.items():
        if simple_hash(row['data']) != row['hash']:
            raise ValueError(f"Error: Data integrity verification failed.")
    return frag.items()

if __name__ == "__main__":
    SIZE = int(sys.argv[1])
    FACTOR = int(sys.argv[2])
    FRAGMENTS = {
        1: {'data': 'Hello', 'hash': simple_hash('Hello')},
        2: {'data': 'World', 'hash': simple_hash('World')},
        3: {'data': '!', 'hash': simple_hash('!')}
    }
    original_data = reconstruct_data(FRAGMENTS)
    print(FRAGMENTS)
    print(original_data)
