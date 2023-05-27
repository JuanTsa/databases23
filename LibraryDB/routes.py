from flask import Flask, render_template
from flask_mysqldb import MySQL
from LibraryDB import app, db

@app.route("/")
def index():
    return render_template("landing.html", pageTitle="Home Page")

@app.route("/login_as")
def login_as():
    return render_template("login_start.html")

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/sign-up")
def sign_up():
    return render_template("signup.html")

@app.route("/signup_message")
def signup_message():
    return render_template("signup_message.html")

@app.route("/books")
def books():
    cur = db.connection.cursor()
    query = """
    SELECT *
    FROM book
    ORDER BY book_id
    """
    cur.execute(query)
    column_names = [i[0] for i in cur.description]
    books = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    #programs = cur.fetchall()
    cur.close()
    return render_template("books.html", pageTitle="Books", books=books)