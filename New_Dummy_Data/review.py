import random

def generate_tuples():
    tuples = []
    for i in range(1, 1001):
        j = random.randint(1, 300)
        z = random.randint(10, 171)
        tuples.append((i, j, z, 'An amazing book, despite my rating indicating otherwise!', random.randint(1, 5), 'Approved'))
    return tuples

tuples = generate_tuples()
for tup in tuples:
    print(f"{tup},")