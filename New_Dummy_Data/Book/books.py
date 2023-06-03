import random

titles = [
    "Don Quixote", "Alice's Adventures in Wonderland", "The Adventures of Huckleberry Finn",
    "The Adventures of Tom Sawyer", "Treasure Island", "Pride and Prejudice", "Wuthering Heights",
    "Jane Eyre", "Moby Dick", "The Scarlet Letter", "Gulliver's Travels", "The Pilgrim's Progress",
    "A Christmas Carol", "David Copperfield", "A Tale of Two Cities", "Little Women", "Great Expectations",
    "The Hobbit, or, There and Back Again", "Frankenstein, or, the Modern Prometheus", "Oliver Twist",
    "Uncle Tom's Cabin", "Crime and Punishment", "Madame Bovary: Patterns of Provincial life",
    "The Return of the King", "Dracula", "The Three Musketeers", "Brave New World", "War and Peace",
    "To Kill a Mockingbird", "The Wizard of Oz", "Les Misérables", "The Secret Garden", "Animal Farm",
    "The Great Gatsby", "The Little Prince", "The Call of the Wild", "20,000 Leagues Under the Sea",
    "Anna Karenina", "The Wind in the Willows", "The Picture of Dorian Gray", "The Grapes of Wrath",
    "Sense and Sensibility", "The Last of the Mohicans", "Tess of the d'Urbervilles",
    "Harry Potter and the Sorcerer's Stone", "Heidi", "Ulysses", "The Complete Sherlock Holmes",
    "The Count of Monte Cristo", "The Old Man and the Sea", "The Lion, the Witch, and the Wardrobe",
    "The Hunchback of Notre Dame", "Pinocchio", "One Hundred Years of Solitude", "Ivanhoe",
    "The Red Badge of Courage", "Anne of Green Gables", "Black Beauty", "Peter Pan",
    "A Farewell to Arms", "The House of the Seven Gables", "Lord of the Flies",
    "The Prince and the Pauper", "A Portrait of the Artist as a Young Man", "Lord Jim",
    "Harry Potter and the Chamber of Secrets", "The Red & the Black", "The Stranger", "The Trial",
    "Lady Chatterley's Lover", "Kidnapped: The Adventures of David Balfour",
    "The Catcher in the Rye", "Fahrenheit 451", "A Journey to the Center of the Earth", "Vanity Fair",
    "All Quiet on the Western Front", "Gone with the Wind", "My Ántonia", "Of Mice and Men",
    "The Vicar of Wakefield", "A Connecticut Yankee in King Arthur's Court", "White Fang",
    "Fathers and Sons", "Doctor Zhivago", "The Decameron", "Nineteen Eighty-Four", "The Jungle",
    "The Da Vinci Code", "Persuasion", "Mansfield Park", "Candide", "For Whom the Bell Tolls",
    "Far from the Madding Crowd", "The Fellowship of the Ring", "The Return of the Native",
    "Sons and Lovers", "Charlotte's Web", "The Swiss Family Robinson", "Bleak House", "Père Goriot",
    "Utopia", "The History of Tom Jones, a Foundling", "Harry Potter and the Prisoner of Azkaban",
    "Kim", "The Sound and the Fury", "Harry Potter and the Goblet of Fire", "The Mill on the Floss",
    "A Wrinkle in Time", "The Hound of the Baskervilles", "The Two Towers", "The War of the Worlds",
    "Middlemarch", "The Age of Innocence", "The Color Purple", "Northanger Abbey", "East of Eden",
    "On the Road", "Catch-22", "Around the World in Eighty Days", "Hard Times", "Beloved",
    "Mrs. Dalloway", "To the Lighthouse", "The Magician's Nephew", "Harry Potter and the Order of the Phoenix",
    "The Sun Also Rises", "The Good Earth", "Silas Marner", "Love in the Time of Cholera", "Rebecca",
    "Jude the Obscure", "Twilight", "A Passage to India", "The Plague", "Nicholas Nickleby", "The Pearl",
    "Ethan Frome", "The Tale of Genji", "The Giver", "The Alchemist",
    "The Strange Case of Dr. Jekyll and Mr. Hyde", "Robinson Crusoe", "Tender is the Night",
    "The Idiot", "Hatchet", "The Kite Runner", "One Flew Over the Cuckoo's Nest",
    "The Portrait of a Lady", "The Outsiders", "Ben-Hur", "The Mayor of Casterbridge", "Cry, The Beloved Country",
    "The Last Battle", "Captains Courageous", "The Castle", "The Metamorphosis", "The Magic Mountain (Der Zauberberg)",
    "James and the Giant Peach", "The Horse and His Boy", "Angels & Demons", "The Voyage of the Dawn Treader",
    "The Bell Jar", "Women in Love", "The Yearling", "O Pioneers!", "The Handmaid's Tale", "The Moonstone",
    "The Old Curiosity Shop", "Little Dorrit", "Prince Caspian: The Return to Narnia", "Sister Carrie",
    "The Silver Chair", "The Hunger Games", "This Side of Paradise", "Eugénie Grandet",
    "Of Human Bondage", "Dream of the Red Chamber", "Life of Pi", "Harry Potter and the Deathly Hallows",
    "Invisible Man", "Steppenwolf", "The Sorrows of Young Werther", "Bridge to Terabithia",
    "The Invisible Man", "Holes", "Siddhartha", "A Tree Grows in Brooklyn",
    "Through the Looking-Glass, and What Alice Found There", "In Cold Blood", "The House of the Spirits",
    "Adam Bede", "The Betrothed", "The Book Thief", "Their Eyes Were Watching God",
    "One Day in the Life of Ivan Denisovich", "The Sea Wolf", "Catching Fire",
    "Roll of Thunder, Hear My Cry", "Death Comes for the Archbishop", "The House of Mirth",
    "Light in August", "The Pickwick Papers", "Remembrance of Things Past",
    "Barchester Towers and the Warden", "The Bridge of San Luis Rey", "The Help",
    "Murder on the Orient Express", "The Lovely Bones", "The Appeal", "Dombey And Son",
    "Slaughterhouse-Five", "An American Tragedy", "The Bluest Eye", "Little House In the Big Woods",
    "Pippi Longstocking", "Germinal", "The Heart Is a Lonely Hunter", "The Woman In White",
    "Absalom, Absalom!", "A Painted House", "The Girl With the Dragon Tattoo",
    "A Room With a View", "Watership Down", "Memoirs of a Geisha", "Our Mutual Friend",
    "Babbitt", "The Red Pony", "All the King's Men", "Things Fall Apart",
    "Lorna Doone", "Johnny Tremain", "Anne of Avonlea", "Tuck Everlasting",
    "The BFG", "Cannery Row", "The Joy Luck Club", "The Silmarillion",
    "Roots", "Little House on the Prairie", "Native Son", "Stuart Little",
    "Cross Fire", "The Power and the Glory", "A Clockwork Orange", "The Phantom of the Opera",
    "The Martian Chronicles", "The Road", "The Way of All Flesh", "Diary of a Wimpy Kid: The Long Haul",
    "Villette", "The Curious Incident of the Dog In the Night-Time", "The Mysterious Island",
    "Song of Solomon", "Nana", "Quo Vadis", "Main Street", "Matilda",
    "Lolita", "Paper Towns", "Sounder", "Are You There God? It's Me, Margaret",
    "The Notebook", "From the Mixed-Up Files of Mrs. Basil E. Frankweiler", "Atlas Shrugged",
    "The Fountainhead", "Number the Stars", "The Firm", "Swann's Way",
    "Ender's Game", "The Name of the Rose", "A Time to Kill", "Water for Elephants",
    "The Time Machine", "Eragon", "The Hitchhiker's Guide to the Galaxy", "Buddenbrooks",
    "A Thousand Splendid Suns", "The Witch of Blackbird Pond", "And Then There Were None",
    "A Separate Peace", "Breaking Dawn", "As I Lay Dying", "The Girl Who Played With Fire",
    "Where the Red Fern Grows", "Le Morte D'Arthur", "Mockingjay", "The Pillars of the Earth",
    "Persian Letters", "The Client", "Sula", "Tales of a Fourth Grade Nothing",
    "The Merry Adventures of Robin Hood of Great Renown In Nottinghamshire", "Tortilla Flat",
    "Look Homeward, Angel", "The Mystery of Edwin Drood", "Brideshead Revisited", "The Pelican Brief",
    "Atonement", "Washington Square"
]

publishers = [
    "Penguin Random House", "Hachette Livre", "HarperCollins", "Simon & Schuster",
    "Macmillan Publishers", "Wiley", "Scholastic Corporation", "Pearson Education",
    "Cengage Learning", "Bloomsbury Publishing", "Springer Nature", "Oxford University Press",
    "Cambridge University Press", "Elsevier", "Abrams Books", "Chronicle Books",
    "Candlewick Press", "Houghton Mifflin Harcourt", "Workman Publishing", "Penguin Group",
    "Random House", "Little, Brown and Company", "W.W. Norton & Company", "Vintage Books",
    "Penguin Classics", "Penguin Books", "Sterling Publishing", "Schiffer Publishing",
    "Farrar, Straus and Giroux", "Grove Atlantic", "Melville House", "Da Capo Press",
    "Penguin Press", "Bloomsbury USA", "Grand Central Publishing", "G.P. Putnam's Sons",
    "Doubleday", "Alfred A. Knopf", "Basic Books", "Knopf Doubleday Publishing Group",
    "Crown Publishing Group", "Scribner", "St. Martin's Press", "Tor Books", "Forge Books",
    "Viking Press", "Ballantine Books", "Random House Trade Paperbacks", "Picador",
    "Anchor Books", "Pocket Books", "Harlequin", "Avon Books", "William Morrow and Company",
    "Zondervan", "HarperOne", "Harper Voyager", "HarperCollins Children's Books",
    "Scholastic Press", "Hodder & Stoughton", "Pan Macmillan", "Puffin Books", "Gollancz",
    "Usborne Publishing", "Bloomsbury Children's Books", "Walker Books", "Houghton Mifflin",
    "Abrams", "DK Publishing", "Wiley-VCH", "Thames & Hudson", "Princeton University Press",
    "Yale University Press", "Harvard University Press", "MIT Press", "University of Chicago Press",
    "Columbia University Press", "Stanford University Press", "University of California Press"
]

languages = [
	'english', 'german', 'french', 'spanish', 'greek', 'italian', 'chinese', 'japanese', 'vietnamese', 'portuguese', 'albanian', 'russian'
]

import random

keywords = [
    'Fiction', 'Nonfiction', 'Mystery', 'Thriller', 'Romance', 'Fantasy',
    'Science Fiction', 'Biography', 'History', 'Self-help', 'Young Adult',
    'Childish', 'Adventure', 'Horror', 'Crime', 'Suspense', 'Memoir',
    'Contemporary', 'Classic', 'Biography', 'Autobiography', 'Travel',
    'Science', 'Art', 'Poetry', 'Spiritual', 'Business', 'Leadership',
    'Philosophy', 'Psychology', 'Health', 'Cooking', 'Parenting',
    'Education', 'Nature', 'Religion', 'Technology', 'Design', 'Gardening',
    'Sports'
]

def generate_isbn(used_isbns):
    isbn = random.randint(10**12, 10**13-1)
    while isbn in used_isbns:
        isbn = random.randint(10**12, 10**13-1)
    used_isbns.add(isbn)
    return isbn

def generate_book_tuples():
    used_isbns = set()
    book_tuples = []
    for i in range(1, 301):
        isbn = generate_isbn(used_isbns)
        school = random.randint(1, 8)
        title = random.choice(titles)
        publisher = random.choice(publishers)
        pages = random.randint(100, 1000)
        cop = random.randint(10, 20)
        language = random.choice(languages)
        keywords_selected = random.sample(keywords, 3)
        book_tuples.append((i, isbn, school, title, publisher, pages, 'A great and intriguing book, essential for any databases project!', cop, language, keywords_selected, cop))
    return book_tuples

book_tuples = generate_book_tuples()

for book_tuple in book_tuples:
    print(book_tuple, end=",\n")

