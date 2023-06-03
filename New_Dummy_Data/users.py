==========
===== operators
==========
import random
def generate_tuples():
    tuples = []
    for i in range(2, 10):
        j = i - 1
        name = f"name{i}"
        surname = f"surname{i}"
        email = f"{name}{surname}@gmail.com"
        age = random.randint(28, 40)
        tuples.append((i, j, f"user{i}", f"pass{i}", name, surname, email, age, "operator", "Approved"))
    return tuples

tuples = generate_tuples()
for tup in tuples:
    print(f"{tup},")


========== 
===== students
==========
import random
def generate_tuples():
    tuples = []
    for i in range(10, 350):
        j = random.randint(1, 8)
        name = f"name{i}"
        surname = f"surname{i}"
        email = f"{name}{surname}@gmail.com"
        age = random.randint(18, 26)
        tuples.append((i, j, f"user{i}", f"pass{i}", name, surname, email, age, "student", "Approved"))
    return tuples

tuples = generate_tuples()
for tup in tuples:
    print(f"{tup},")


==========
===== teachers
==========
import random
def generate_tuples():
    tuples = []
    for i in range(351, 452):
        j = random.randint(1, 8)
        name = f"name{i}"
        surname = f"surname{i}"
        email = f"{name}{surname}@gmail.com"
        age = random.randint(28, 69)
        tuples.append((i, j, f"user{i}", f"pass{i}", name, surname, email, age, "teacher", "Approved"))
    return tuples

tuples = generate_tuples()
for tup in tuples:
    print(f"{tup},")
