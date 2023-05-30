import random

def generate_random_number(min_val, max_val):
    return random.randint(min_val, max_val)

def generate_review_entry(i, j, id):
    review = "An awesome, page-turner, book. My review doesn't apply to my rating!"
    rating = generate_random_number(1, 5)
    status = "Approved"
    return f"({i}, '{review}', {j}, {id}, {rating}, '{status}'),"

# Main program
for i in range(1, 201):
    j = generate_random_number(1, 150)
    id = generate_random_number(1, 80)
    entry = generate_review_entry(i, j, id)
    print(entry)
