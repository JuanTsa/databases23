import random
import datetime

def generate_random_number(min_val, max_val):
    return random.randint(min_val, max_val)

def generate_random_date():
    start_date = datetime.date(2022, 1, 1)
    end_date = datetime.date(2022, 12, 31)
    random_date = start_date + datetime.timedelta(days=random.randint(0, (end_date - start_date).days))
    return random_date.strftime("%Y-%m-%d")

for i in range(1, 51):
    j = generate_random_number(1, 150)
    id = generate_random_number(1, 80)
    request_date = generate_random_date()
    status = "Approved"
    
    print(f"({i}, {j}, {id}, '{request_date}', '{status}'),")
