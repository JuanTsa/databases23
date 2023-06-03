import random
from datetime import datetime, timedelta

def generate_borrow_tuples():
    borrow_tuples = []
    for i in range(1, 201):
        j = random.randint(1, 300)
        user = random.randint(10, 171)
        borrow_date = datetime.now() - timedelta(days=random.randint(1, 365))
        returning_date = borrow_date + timedelta(days=random.randint(1, 7))
        borrow_tuples.append((i, j, user, borrow_date.strftime('%Y-%m-%d'), returning_date.strftime('%Y-%m-%d'), 'Approved'))
    return borrow_tuples

borrow_tuples = generate_borrow_tuples()

for borrow_tuple in borrow_tuples:
    print(borrow_tuple, end=",\n")