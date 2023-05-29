import random

def generate_random_number(min_val, max_val):
    return random.randint(min_val, max_val)

def generate_random_string(strings):
    return random.choice(strings)

def generate_book_entry(i, title):
    isbn = generate_random_number(1000000000000, 9999999999999)
    j = generate_random_number(1, 5)
    publishers = [
        "Penguin Random House", "Harper Collins", "Simon & Schuster", "Hachette Livre",
        "Macmillan Publishers", "Bloomsbury Publishing", "Scholastic Corporation",
        "Pearson Education", "Oxford University Press", "Cambridge University Press",
        "Springer Nature", "Elsevier", "Vintage Books", "Faber & Faber", "Penguin Books",
        "Penguin Classics", "Little, Brown and Company", "Knopf Doubleday Publishing Group",
        "Candlewick Press", "Abrams Books", "Chronicle Books", "Grove Atlantic",
        "W. W. Norton & Company", "Hay House", "Pan Macmillan", "Allen Lane", "Penguin Press",
        "Tor Books", "Bloomsbury Academic", "University of Chicago Press",
        "Harvard University Press", "MIT Press", "Random House", "St. Martin's Press",
        "Farrar, Straus and Giroux", "Yale University Press", "Vintage Classics",
        "Canongate Books", "Picador", "Penguin Modern Classics", "Viking Press",
        "Penguin India", "Penguin Canada", "Blackwell Publishing", "Wiley", "Quirk Books",
        "Orbit Books", "Andrés Bello Editorial", "Fantagraphics Books", "Dark Horse Comics"
    ]
    pages = generate_random_number(100, 1000)
    summary = 'A unique and intriguing book, full of wonders and plot'
    available_copies = generate_random_number(0, 20)
    cover = 'https://hotemoji.com/images/dl/1/orange-book-emoji-by-twitter.png'
    languages = ['english', 'greek', 'spanish', 'russian', 'japanese', 'chinese', 'french', 'german', 'italian', 'urdu']
    keywords = [
        'Fiction', 'Non-fiction', 'Mystery', 'Romance', 'Science fiction', 'Fantasy', 'Biography',
        'History', 'Thriller', 'Adventure', 'Memoir', 'Poetry', 'Self-help', 'Young adult',
        "Children's", 'Dystopian', 'Classic', 'Contemporary', 'Suspense', 'Horror', 'Crime',
        'Autobiography', 'Philosophy', 'Science', 'Art', 'Travel', 'Drama', 'Mythology',
        'Cookbook', 'Psychology', 'Religion', 'Business', 'Parenting', 'Education', 'Nature',
        'Health', 'Politics', 'Technology', 'Graphic novel', 'Memoir', 'Historical fiction',
        'Comedy', 'Biography', 'Young adult fantasy', 'Self-improvement', 'Sociology',
        'Anthology', 'Cultural studies', 'Environmental', 'Music'
    ]
    language = generate_random_string(languages)
    keyword = generate_random_string(keywords)
    inventory = generate_random_number(available_copies, 20)
    total_borrowings = generate_random_number(0, 100)

    return f"({i}, {isbn}, {j}, '{title}', '{generate_random_string(publishers)}', {pages}, '{summary}', {available_copies}, '{cover}', '{language}', '{keyword}', {inventory}, {total_borrowings}),"

input_file = open('book_titles.txt', 'r', encoding='utf-8')
output_file = open("entries.txt", "w", encoding="utf-8")

i = 1  # Counter for book entries

for line in input_file:
    title = line.strip()
    if title:
        entry = generate_book_entry(i, title)
        output_file.write(entry + '\n')
        i += 1

input_file.close()
output_file.close()

print("Book entries have been generated and saved to entries.txt.")
