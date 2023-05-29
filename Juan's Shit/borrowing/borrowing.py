import random
import datetime

def generate_random_number(min_val, max_val):
    return random.randint(min_val, max_val)

def generate_random_date(start_date, end_date):
    random_date = start_date + datetime.timedelta(days=random.randint(0, (end_date - start_date).days))
    return random_date.strftime("%Y-%m-%d")

start_date = datetime.date(2022, 1, 1)
end_date = datetime.date(2022, 12, 31)

for i in range(1, 61):
    j = generate_random_number(1, 150)
    id = generate_random_number(1, 80)
    borrow_date = generate_random_date(start_date, end_date)
    due_date = (datetime.datetime.strptime(borrow_date, "%Y-%m-%d") + datetime.timedelta(days=7)).strftime("%Y-%m-%d")
    returning_date = generate_random_date(datetime.datetime.strptime(borrow_date, "%Y-%m-%d").date(), end_date)
    status = "Approved"

    print(f"({i}, {j}, {id}, '{borrow_date}', '{due_date}', '{returning_date}', '{status}'),")
