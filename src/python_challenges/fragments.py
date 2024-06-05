# Initial fragments dictionary
fragments = {
    1: {'data': 'Hello', 'hash': 'hhhh'},
    2: {'data': 'World', 'hash': 'wwww'},
    3: {'data': '!', 'hash': '!!!!'}
}

# Adding a new fragment
fragments[4] = {'data': 'Python', 'hash': 'pppp'}

# Updating fragment with key 2
fragments[2]['data'] = 'Universe'
fragments[2]['hash'] = 'uuuu'

# Deleting fragment with key 3
del fragments[3]

# Retrieving fragment with key 1
fragment = fragments.get(1)
print(f"Retrieved Fragment: {fragment}")

# Iterating over all fragments
for key, value in fragments.items():
    print(f"Key: {key}, Data: {value['data']}, Hash: {value['hash']}")

# Simple hash function
def simple_hash(input_string):
    return ''.join(chr((ord(char) + 3) % 256) for char in input_string)

# Compute and update hash for each fragment
for key, value in fragments.items():
    value['hash'] = simple_hash(value['data'])

print(fragments)
print(simple_hash(fragments[2]['data']))