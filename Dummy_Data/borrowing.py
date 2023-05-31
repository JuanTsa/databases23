import random
import datetime

def generate_unique_random_number(min_val, max_val, used_numbers):
    num = random.randint(min_val, max_val)
    while num in used_numbers:
        num = random.randint(min_val, max_val)
    used_numbers.add(num)
    return num

def generate_random_date(start_date, end_date):
    random_date = start_date + datetime.timedelta(days=random.randint(0, (end_date - start_date).days))
    return random_date.strftime("%Y-%m-%d")

start_date = datetime.date(2022, 1, 1)
end_date = datetime.date(2022, 12, 31)
used_j = set()
used_id = set()

for i in range(1, 131):
    j = generate_unique_random_number(1, 150, used_j)
    id = generate_unique_random_number(1, 80, used_id)
    borrow_date = generate_random_date(start_date, end_date)
    due_date = (datetime.datetime.strptime(borrow_date, "%Y-%m-%d") + datetime.timedelta(days=7)).strftime("%Y-%m-%d")
    returning_date = generate_random_date(datetime.datetime.strptime(borrow_date, "%Y-%m-%d").date(), end_date)
    status = "Approved"

    print(f"({i}, {j}, {id}, '{borrow_date}', '{due_date}', '{returning_date}', '{status}'),")
