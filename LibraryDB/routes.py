from flask import Flask, render_template, request, session, redirect, url_for, flash
from werkzeug.security import check_password_hash
from flask_mysqldb import MySQL
from LibraryDB import app, db


@app.route("/")
def index():
    return render_template("landing.html", pageTitle="Home Page")

@app.route("/login")
def login():
    return render_template("login.html", pageTitle="Home Page")

@app.route("/admin")
def admin():
     return render_template("admin.html", pageTitle="Home Page")

@app.route("/operator")
def operatot():
     return render_template("operator.html", pageTitle="Home Page")

@app.route("/teacher")
def teacher():
     return render_template("teacher.html", pageTitle="Home Page")

@app.route("/student")
def student():
     return render_template("student.html", pageTitle="Home Page")
@app.route("/login/processing", methods=['POST'])
def login_proc():
    username=request.form['Username']
    password=request.form['Password']

    cursor = db.connection.cursor()
    query = "SELECT * FROM `User` WHERE `Username`=%s AND `Password`=%s"
    cursor.execute(query, (username, password))
    user = cursor.fetchone()
    if user:
        role = user[11] 
        if role == 'Administrator':
            return redirect('/admin')
        elif role == 'Operator':
            return redirect('/operator')
        elif role == 'Teacher':
            return redirect('/teacher') 
        elif role == 'Student':
            return redirect('/student')
        else: return 'Unkown role'
    else:
        return 'Invalid username or password'

@app.route("/sign-up", methods=["GET", "POST"])
def sign_up():
    if request.method == "GET":
        return render_template("signup.html")
    else:
        User_Type=request.form['User Type']
        First_Name=request.form['First Name']
        Last_Name=request.form['Last Name']
        Email=request.form['Email']
        Age=request.form['Age']
        Username=request.form['Username']
        Password=request.form['Password']
        
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `User` (`Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`)\
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (Username, Password, First_Name, Last_Name, Email, Age, 0, 0, 0, 0, User_Type))
        db.connection.commit()
        return redirect('signup_message')


@app.route("/signup_message")
def signup_message():
    return render_template("signup_message.html")

@app.route("/books")
def books():
    cur = db.connection.cursor()
    query = """
    SELECT *
    FROM Book
    ORDER BY Book_ID
    """
    cur.execute(query)
    column_names = [i[0] for i in cur.description]
    books = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("books.html", pageTitle="Books", books=books)

