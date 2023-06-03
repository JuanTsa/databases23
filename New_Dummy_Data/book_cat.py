import random

def generate_tuples():
    tuples = []
    i = 1
    for j in range(1, 301):
        tuples.append((i, j),)
        i += 1
        if i > 30:
            i = 1
    return tuples

tuples = generate_tuples()
for tup in tuples:
    print(f"{tup},")

# Generate 200 more tuples with random 'i' values
for _ in range(200):
    i = random.randint(1, 20)
    j = random.randint(1, 300)
    new_tuple = (i, j)
    if new_tuple not in tuples:
        tuples.append(new_tuple)
        print(f"{new_tuple},")
