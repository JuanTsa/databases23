from flask import Flask, render_template, request, session, redirect, url_for, flash
from flask_mysqldb import MySQL
from LibraryDB import app, db


@app.route("/")
def login():
    return render_template("login.html")

@app.route("/home")
def home():
    role=session['User_Type']
    return render_template("home.html", role=role, pageTitle="Home Page")

@app.route("/login", methods=['POST'])
def login_proc():
    username=request.form['Username']
    password=request.form['Password']
    status="Approved"
    cursor = db.connection.cursor()
    query = "SELECT * FROM `User` WHERE `Username`=%s AND `Password`=%s AND `Status`=%s"
    cursor.execute(query, (username, password, status))
    user = cursor.fetchone()
    cursor.close()
    if user:
        role = user[12] 
        id = user[0]
        school_id = user[1]
        session['User_ID']=id
        session['Username']=username
        session['Password']=password
        session['User_Type']=role
        session['School_ID']=school_id
        return redirect('/home')
    else:
        return 'Invalid username or password or application still on hold'

@app.route("/sign-up", methods=["GET", "POST"])
def sign_up():
    if request.method == "GET":
        cur = db.connection.cursor()
        cur.execute("Select * FROM `School_Unit`")
        column_names = [i[0] for i in cur.description]
        schools = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
        cur.close()
        return render_template("signup.html", schools=schools)
    else:
        User_Type=request.form['User Type']
        School_Name=request.form['School']
        First_Name=request.form['First Name']
        Last_Name=request.form['Last Name']
        Email=request.form['Email']
        Age=request.form['Age']
        Username=request.form['Username']
        Password=request.form['Password']
        cur = db.connection.cursor()
        query="SELECT * FROM `School_Unit` WHERE `School_Name`=%s"
        cur.execute(query, [School_Name])
        school = cur.fetchone()
        cur.close()
        School_ID = school[0]
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `Copies_Borrowed`, `Copies_Reserved`, `Max_Copies_Borrowed`, `Max_Copies_Reserved`, `User_Type`, `Status`)\
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (School_ID, Username, Password, First_Name, Last_Name, Email, Age, 0, 0, 0, 0, User_Type, 'On Hold'))
        db.connection.commit()
        cur.close()
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

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

@app.route('/home/new_operators')
def new_operators():
    cur = db.connection.cursor()
    cur.execute("SELECT * FROM `User` WHERE `Status`='On Hold' AND `User_Type`='Operator'")
    column_names = [i[0] for i in cur.description]
    users = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("new_operators.html", pageTitle="New Operators", users=users)

@app.route('/home/new_operators/accept/<int:User_ID>')
def accept_operator(User_ID):
    cur = db.connection.cursor()
    cur.execute("UPDATE `User` SET `Status`='Approved' WHERE `User_ID`=%s", (User_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_operators')

@app.route('/home/new_operators/reject/<int:User_ID>')
def reject_operator(User_ID):
    cur = db.connection.cursor()
    cur.execute("DELETE FROM `User` WHERE `User_ID`=%s", (User_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_operators')

@app.route('/home/new_users')
def new_users():
    School_ID=session['School_ID']
    cur = db.connection.cursor()
    cur.execute("SELECT * FROM `User` WHERE `Status`='On Hold' AND (`User_Type`='Teacher' OR `User_Type`='Student') AND `School_ID`=%s", (School_ID,))
    column_names = [i[0] for i in cur.description]
    users = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("new_users.html", pageTitle="New Users", users=users)

@app.route('/home/new_users/accept/<int:User_ID>')
def accept_user(User_ID):
    cur = db.connection.cursor()
    cur.execute("UPDATE `User` SET `Status`='Approved' WHERE `User_ID`=%s", (User_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_users')

@app.route('/home/new_users/reject/<int:User_ID>')
def reject_user(User_ID):
    cur = db.connection.cursor()
    cur.execute("DELETE FROM `User` WHERE `User_ID`=%s", (User_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_users')

@app.route('/home/schools')
def school_units():
    cur = db.connection.cursor()
    cur.execute("SELECT * FROM `School_Unit`")
    column_names = [i[0] for i in cur.description]
    schools = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("schools.html", schools=schools, pageTitle="Schools")

@app.route("/home/schools/add", methods=["GET", "POST"])
def add_school():
    if request.method == "GET":
        return render_template("add_school.html")
    else:
        School_Name=request.form['School Name']
        Address=request.form['Address']
        Phone=request.form['Phone']
        Email=request.form['Email']
        Principal_Name=request.form['Principal Name']
        Principal_Surname=request.form['Principal Surname']
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `School_Unit` (`School_Name`, `Address`, `Phone`, `Email`, `Principal_Name`, `Principal_Surname`)\
                     VALUES (%s, %s, %s, %s, %s, %s)", (School_Name, Address, Phone, Email, Principal_Name, Principal_Surname))
        db.connection.commit()
        cur.close()
        return redirect('/home/schools')
    
@app.route("/home/authors_in_category")
def author_query():
    cur = db.connection.cursor()
    cur.execute("SELECT * FROM `Category`")
    column_names = [i[0] for i in cur.description]
    categories = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("authors_in_category.html", categories=categories, pageTitle="Authors in Category")

  
@app.route("/home/authors_in_category/search", methods=['POST'])
def execute_author():
    Category_Name=request.form['Category']
    cur = db.connection.cursor()
    cur.execute("SELECT DISTINCT a.Author_Name, a.Author_Surname FROM Author a JOIN Book_Author ba ON a.Author_ID = ba.Author_ID JOIN Book_Category bc ON ba.Book_ID = bc.Book_ID JOIN Category c ON bc.Category_ID = c.Category_ID WHERE c.Category_Name =%s", (Category_Name,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_author.html", results=results, pageTitle="Authors in Category")

@app.route("/home/teachers_in_category")
def teacher_query():
    cur = db.connection.cursor()
    cur.execute("SELECT * FROM `Category`")
    column_names = [i[0] for i in cur.description]
    categories = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("teacher_in_category.html", categories=categories, pageTitle="Teacher Borrower Per Category")

@app.route("/home/teachers_in_category/search", methods=['POST'])
def execute_teacher():
    Category_Name=request.form['Category']
    cur = db.connection.cursor()
    cur.execute("SELECT DISTINCT U.Name, U.Surname FROM User U JOIN Borrowing B ON U.User_ID = B.User_ID JOIN Book_Category BC ON B.Book_ID = BC.Book_ID JOIN Category C ON BC.Category_ID = C.Category_ID WHERE U.User_Type = 'Teacher' AND C.Category_Name =%s AND B.Borrow_Date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR);", (Category_Name,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_teacher.html", results=results, pageTitle="Authors in Category")

@app.route("/home/borrowings_per_school")
def borrowings_per_school():
    return render_template("borrowings_per_school.html", pageTitle="Borrowings Per School")

@app.route("/home/borrowings_per_school/search", methods=['POST'])
def execute_borrowings():
    Year=request.form['Year']
    Month=request.form['Month']
    cur = db.connection.cursor()
    cur.execute("SELECT s.School_Name, YEAR(b.Borrow_Date) AS Borrow_Year, MONTH(b.Borrow_Date) AS Borrow_Month, COUNT(*) AS Total_Borrowings FROM School_Unit s INNER JOIN User u ON s.School_ID = u.School_ID INNER JOIN Borrowing b ON u.User_ID = b.User_ID WHERE YEAR(b.Borrow_Date) = %s AND MONTH(b.Borrow_Date) = %s GROUP BY s.School_ID, YEAR(b.Borrow_Date), MONTH(b.Borrow_Date) ORDER BY s.School_Name;", (Year, Month))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_borrowings.html", results=results, pageTitle="Borrowings Per School")

@app.route("/home/young_teachers")
def execute_young_teachers():
    cur =db.connection.cursor()
    cur.execute("SELECT U.User_ID, U.Name, U.Surname, U.Age, COUNT(*) AS NumOfBooksBorrowed FROM User U JOIN Borrowing B ON U.User_ID = B.User_ID JOIN Book BK ON B.Book_ID = BK.Book_ID WHERE U.User_Type = 'Teacher' AND U.Age < 40 GROUP BY U.User_ID ORDER BY NumOfBooksBorrowed DESC;")
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_young_teachers.html", results=results, pageTitle="Young Teachers")

@app.route("/home/lonely_authors")
def execute_lonely_authors():
    cur =db.connection.cursor()
    cur.execute("SELECT a.Author_ID, a.Author_Name, a.Author_Surname FROM Author a JOIN Book_Author ba ON a.Author_ID = ba.Author_ID LEFT JOIN Book b ON ba.Book_ID = b.Book_ID LEFT JOIN Borrowing bor ON b.Book_ID = bor.Book_ID GROUP BY a.Author_ID, a.Author_Name, a.Author_Surname HAVING COUNT(DISTINCT bor.Borrowing_ID) = 0;")
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_lonely_authors.html", results=results, pageTitle="Lonely Authors")

@app.route("/home/same_loans")
def same_loans():
    return render_template("same_loans.html", pageTitle="Same Loans")

@app.route("/home/same_loans/search", methods=['POST'])
def execute_same_loans():
    Year=request.form['Year']
    cur = db.connection.cursor()
    cur.execute("SELECT op.User_ID, op.Name, op.Surname, sb.Total_Borrowings FROM ( SELECT su.School_ID, COUNT(bor.Borrowing_ID) AS Total_Borrowings FROM School_Unit su JOIN User u ON su.School_ID = u.School_ID JOIN Borrowing bor ON u.User_ID = bor.User_ID WHERE YEAR(bor.Borrow_Date) = %s GROUP BY su.School_ID HAVING COUNT(bor.Borrowing_ID) > 20 ) sb JOIN ( SELECT u.User_ID, u.Name, u.Surname, u.School_ID FROM User u WHERE u.User_Type = 'Operator' ) op ON sb.School_ID = op.School_ID WHERE sb.Total_Borrowings = ( SELECT COUNT(bor.Borrowing_ID) AS Total_Borrowings FROM Borrowing bor WHERE bor.User_ID = op.User_ID AND YEAR(bor.Borrow_Date) = %s GROUP BY bor.User_ID );", (Year, Year))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_same_loans.html", results=results, pageTitle="Same Loans")

@app.route("/home/best_pairs")
def best_pairs():
    cur =db.connection.cursor()
    cur.execute("SELECT C1.Category_Name AS Category1, C2.Category_Name AS Category2, COUNT(*) AS BorrowingCount FROM Book_Category BC1 JOIN Book_Category BC2 ON BC1.Book_ID = BC2.Book_ID AND BC1.Category_ID < BC2.Category_ID JOIN Book B ON BC1.Book_ID = B.Book_ID JOIN Borrowing BR ON B.Book_ID = BR.Book_ID JOIN Category C1 ON BC1.Category_ID = C1.Category_ID JOIN Category C2 ON BC2.Category_ID = C2.Category_ID GROUP BY C1.Category_Name, C2.Category_Name ORDER BY BorrowingCount DESC LIMIT 3;")
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("best_pairs.html", results=results, pageTitle="Best Pairs")

@app.route("/home/less_books_than")
def less_books_than():
    cur =db.connection.cursor()
    cur.execute("SELECT A.`Author_ID`, A.`Author_Name`, A.`Author_Surname`, A.`Books_Written` FROM `Author` A WHERE A.`Books_Written` < (  SELECT MAX(`Books_Written`) - 4 FROM `Author` ) ORDER BY A.`Books_Written` DESC;")
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("less_books_than.html", results=results, pageTitle="Authors with at least 5 books less than author with max")

@app.route("/home/late_borrowed")
def late_borrowed():
    return render_template("late_borrowed.html", pageTitle="Late Borrowed")

@app.route("/home/late_borrowed/search", methods=['POST'])
def execute_late_borrowed():
    Operator_School_ID=session['School_ID']
    Option=request.form['Option']
    Input=request.form['Input']
    cur =db.connection.cursor()
    if Option == 'Username':
            cur.execute("SELECT u.User_ID, u.Name, u.Surname, u.Username, DATEDIFF(CURDATE(), bor.Due_Date) AS Delay_Days FROM User u JOIN Borrowing bor ON u.User_ID = bor.User_ID WHERE DATEDIFF(CURDATE(), bor.Due_Date) > 0 AND u.Username LIKE %s AND bor.Returning_Date IS NULL AND u.School_ID=%s GROUP BY u.User_ID, u.Name, u.Surname;", ('%'+Input+'%', Operator_School_ID))
    else:
            cur.execute("SELECT u.User_ID, u.Name, u.Surname, u.Username, DATEDIFF(CURDATE(), bor.Due_Date) AS Delay_Days FROM User u JOIN Borrowing bor ON u.User_ID = bor.User_ID WHERE DATEDIFF(CURDATE(), bor.Due_Date) > 0 AND DATEDIFF(CURDATE(), bor.Due_Date) > %s AND bor.Returning_Date IS NULL AND u.School_ID=%s GROUP BY u.User_ID, u.Name, u.Surname;", (Input, Operator_School_ID))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_late_borrowed.html", results=results, pageTitle="Late Borrowed")

@app.route("/home/average_rating")
def average_rating():
    return render_template("average_rating.html", pageTitle="Average Rating")

@app.route("/home/average_rating/search", methods=['POST'])
def execute_average_rating():
    Operator_School_ID=session['School_ID']
    Option=request.form['Option']
    Input=request.form['Input']
    cur =db.connection.cursor()
    if Option == 'Username':
            cur.execute("SELECT u.User_ID, u.Name, u.Surname, u.Username, AVG(r.Rating) AS Average_Rating FROM User u JOIN Review r ON u.User_ID = r.User_ID WHERE (u.User_Type = 'Student' OR u.User_Type = 'Teacher') AND u.Username LIKE %s AND u.School_ID=%s GROUP BY u.User_ID, u.Name, u.Surname;", ('%'+Input+'%', Operator_School_ID))
    else:
            cur.execute("SELECT u.User_ID, u.Name, u.Surname, u.Username, AVG(r.Rating) AS Average_Rating FROM User u JOIN Review r ON u.User_ID = r.User_ID JOIN Book b ON r.Book_ID = b.Book_ID JOIN Book_Category bc ON b.Book_ID = bc.Book_ID JOIN Category c ON bc.Category_ID = c.Category_ID WHERE (u.User_Type = 'Student' OR u.User_Type = 'Teacher') AND c.Category_Name LIKE %s AND u.School_ID=%s GROUP BY u.User_ID, u.Name, u.Surname;", ('%'+Input+'%', Operator_School_ID))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_average_rating.html", results=results, pageTitle="Average Rating")

@app.route("/home/borrowings_in_school")
def history_or_active():
    return render_template("history_or_active.html", pageTitle="Borrowings In School")

@app.route("/home/borrowings_in_school/history")
def borrowings_in_school_history():
    Operator_School_ID=session['School_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.School_ID =  %s AND b.Status = 'Approved';", (Operator_School_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("borrowings_in_school_history.html", results=results, pageTitle="Borrowings In School History")

@app.route("/home/borrowings_in_school/active")
def borrowings_in_school_active():
    Operator_School_ID=session['School_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.School_ID = %s AND b.Status = 'Approved' AND (b.Returning_Date IS NULL OR b.Returning_Date = '');", (Operator_School_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("borrowings_in_school_active.html", results=results, pageTitle="Borrowings In School Active")

@app.route("/home/reservations_in_school")
def reservations_in_school():
    Operator_School_ID=session['School_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status FROM Reservation r INNER JOIN User u ON r.User_ID = u.User_ID INNER JOIN Book bk ON r.Book_ID = bk.Book_ID WHERE u.School_ID =  %s AND r.Status = 'Approved';", (Operator_School_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("reservations_in_school.html", results=results, pageTitle="Reservations In School")

@app.route("/home/my_borrowings")
def history_or_active_my_borrowings():
    return render_template("my_history_or_active.html", pageTitle="My Borrowings")

@app.route("/home/my_borrowings/history")
def my_borrowings_history():
    User_ID=session['User_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.User_ID = %s;", (User_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("my_borrowings_history.html", results=results, pageTitle="My Borrowings History")

@app.route("/home/my_borrowings/active")
def my_borrowings_active():
    User_ID=session['User_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.User_ID = %s AND (b.Returning_Date IS NULL OR b.Returning_Date = '');", (User_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("my_borrowings_active.html", results=results, pageTitle="My Borrowings Active")

@app.route("/home/my_reservations")
def my_reservations():
    User_ID=session['User_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status FROM Reservation r INNER JOIN User u ON r.User_ID = u.User_ID INNER JOIN Book bk ON r.Book_ID = bk.Book_ID WHERE u.User_ID = %s AND r.Status = 'Approved';", (User_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("my_reservations.html", results=results, pageTitle="My Reservations")

@app.route("/home/update_profile")
def update_profile():
    User_ID=session['User_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT * FROM `User` WHERE `User_ID`=%s", (User_ID,))
    user = cur.fetchone()
    cur.close()
    return render_template("update_profile.html", user=user, pageTitle="Update Profile")

@app.route("/home/update_profile/execute", methods=['POST'])
def update_profile_execute():
    User_ID=session['User_ID']
    Name=request.form['First Name']
    Surname=request.form['Last Name']
    Email=request.form['Email']
    Age=request.form['Age']
    Username=request.form['Username']
    Password=request.form['Password']
    cur = db.connection.cursor()
    cur.execute("UPDATE `User` SET `Name`=%s, `Surname`=%s, `Email`=%s, `Age`=%s, `Username`=%s, `Password`=%s WHERE `User_ID`=%s", (Name, Surname, Email, Age, Username, Password, User_ID))
    db.connection.commit()
    cur.close()
    return redirect('/home')