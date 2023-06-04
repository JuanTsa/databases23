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
        role = user[11] 
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
        cur.execute("INSERT INTO `User` (`School_ID`, `Username`, `Password`, `Name`, `Surname`, `Email`, `Age`, `User_Type`, `Status`)\
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", (School_ID, Username, Password, First_Name, Last_Name, Email, Age, User_Type, 'On Hold'))
        db.connection.commit()
        cur.close()
        return redirect('signup_message')


@app.route("/signup_message")
def signup_message():
    return render_template("signup_message.html")


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
    cur.execute("SELECT sq.School_ID, sq.School_Name, u.Name AS Operator_Name, u.Surname AS Operator_Surname, sq.Total_Borrowings FROM ( SELECT su.School_ID, su.School_Name, COUNT(*) AS Total_Borrowings FROM School_Unit su INNER JOIN User u ON su.School_ID = u.School_ID INNER JOIN Borrowing b ON u.User_ID = b.User_ID WHERE YEAR(b.Borrow_Date) = %s GROUP BY su.School_ID HAVING COUNT(*) >= 20 ) AS sq INNER JOIN ( SELECT Total_Borrowings FROM ( SELECT COUNT(*) AS Total_Borrowings FROM School_Unit su INNER JOIN User u ON su.School_ID = u.School_ID INNER JOIN Borrowing b ON u.User_ID = b.User_ID WHERE YEAR(b.Borrow_Date) = %s GROUP BY su.School_ID HAVING COUNT(*) >= 20 ) AS t GROUP BY Total_Borrowings HAVING COUNT(*) > 1 ) AS t2 ON sq.Total_Borrowings = t2.Total_Borrowings INNER JOIN User u ON sq.School_ID = u.School_ID WHERE u.User_Type = 'Operator' ORDER BY sq.Total_Borrowings DESC; ", (Year, Year))
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
    cur.execute("SELECT A.Author_ID, A.Author_Name, A.Author_Surname, COUNT(*) AS Books_Written FROM Author A JOIN Book_Author BA ON A.Author_ID = BA.Author_ID GROUP BY A.Author_ID, A.Author_Name, A.Author_Surname HAVING Books_Written <= ( SELECT COUNT(*) - 5 FROM Book_Author GROUP BY Author_ID ORDER BY COUNT(*) DESC LIMIT 1) ORDER BY Books_Written DESC;")
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
    if Option == 'First Name':
            cur.execute("SELECT u.User_ID, u.Name, u.Surname, u.Username, DATEDIFF(CURDATE(), bor.Due_Date) AS Delay_Days FROM User u JOIN Borrowing bor ON u.User_ID = bor.User_ID WHERE DATEDIFF(CURDATE(), bor.Due_Date) > 0 AND u.Name LIKE %s AND bor.Returning_Date IS NULL AND u.School_ID=%s GROUP BY u.User_ID, u.Name, u.Surname;", ('%'+Input+'%', Operator_School_ID))
    elif Option == 'Last Name':
            cur.execute("SELECT u.User_ID, u.Name, u.Surname, u.Username, DATEDIFF(CURDATE(), bor.Due_Date) AS Delay_Days FROM User u JOIN Borrowing bor ON u.User_ID = bor.User_ID WHERE DATEDIFF(CURDATE(), bor.Due_Date) > 0 AND u.Surname LIKE %s AND bor.Returning_Date IS NULL AND u.School_ID=%s GROUP BY u.User_ID, u.Name, u.Surname;", ('%'+Input+'%', Operator_School_ID))
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
     return render_template("borrowings_in_school_active.html",  pageTitle="Borrowings In School Active")

@app.route("/home/borrowings_in_school/active/search", methods=['POST'])
def borrowings_in_school_active_search():
    Operator_School_ID=session['School_ID']
    Option=request.form['Option']
    Input=request.form['Input']
    cur =db.connection.cursor()
    if Option == 'All':
          cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.School_ID = %s AND b.Status = 'Approved' AND (b.Returning_Date IS NULL OR b.Returning_Date = '');", (Operator_School_ID,))
    else:
          cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.School_ID = %s AND b.Status = 'Approved' AND u.Username LIKE %s AND (b.Returning_Date IS NULL OR b.Returning_Date = '');", (Operator_School_ID, '%'+Input+'%'))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_borrowing_active.html", results=results, pageTitle="Borrowings In School Active")

@app.route("/home/borrowings_in_school/returned/<int:Borrowing_ID>")
def returned_book(Borrowing_ID):
    cur =db.connection.cursor()
    cur.execute("UPDATE `Borrowing` SET `Returning_Date`= CURRENT_DATE()  WHERE `Borrowing_ID`=%s", (Borrowing_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home')


@app.route("/home/reservations_in_school")
def reservations_in_school():
    return render_template("reservations_in_school.html", pageTitle="Reservations In School")

@app.route("/home/reservations_in_school/search", methods=['POST'])
def reservations_in_school_search():
    Operator_School_ID=session['School_ID']
    Option=request.form['Option']
    Input=request.form['Input']
    cur =db.connection.cursor()
    if Option=='All':
            cur.execute("SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status FROM Reservation r INNER JOIN User u ON r.User_ID = u.User_ID INNER JOIN Book bk ON r.Book_ID = bk.Book_ID WHERE u.School_ID =  %s AND r.Status = 'Approved';", (Operator_School_ID,))
    else:
            cur.execute("SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status FROM Reservation r INNER JOIN User u ON r.User_ID = u.User_ID INNER JOIN Book bk ON r.Book_ID = bk.Book_ID WHERE u.School_ID =  %s AND u.Username LIKE %s AND r.Status = 'Approved';", (Operator_School_ID, '%'+Input+'%'))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_reservations_in_school.html", results=results, pageTitle="Reservations In School")

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
    cur.execute("SELECT b.Borrowing_ID, b.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, b.Borrow_Date, b.Due_Date, b.Returning_Date, b.Status FROM Borrowing b INNER JOIN User u ON b.User_ID = u.User_ID INNER JOIN Book bk ON b.Book_ID = bk.Book_ID WHERE u.User_ID = %s AND (b.Returning_Date IS NULL OR b.Returning_Date = '');", (User_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("my_borrowings_active.html", results=results, pageTitle="My Borrowings Active")

@app.route("/home/my_reservations")
def my_reservations():
    User_ID=session['User_ID']
    cur =db.connection.cursor()
    cur.execute("SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, u.User_Type, r.Request_Date, r.Status FROM Reservation r INNER JOIN User u ON r.User_ID = u.User_ID INNER JOIN Book bk ON r.Book_ID = bk.Book_ID WHERE u.User_ID = %s;", (User_ID,))
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

@app.route("/home/new_borrowings")
def new_borrowings():
    School_ID=session['School_ID']
    cur = db.connection.cursor()
    cur.execute("SELECT br.Borrowing_ID, br.Book_ID, bk.Title, u.Username, u.Name, u.Surname, br.Borrow_Date, br.Due_Date, br.Returning_Date FROM Borrowing br INNER JOIN User u ON br.User_ID = u.User_ID INNER JOIN Book bk ON br.Book_ID = bk.Book_ID WHERE u.School_ID = %s AND br.Status = 'On Hold';", (School_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("new_borrowings.html", pageTitle="New Borrowings", results=results)

@app.route("/home/new_borrowings/accept/<int:Borrowing_ID>")
def accept_borrowing(Borrowing_ID):
    cur = db.connection.cursor()
    cur.execute("UPDATE `Borrowing` SET `Status`='Approved' WHERE `Borrowing_ID`=%s", (Borrowing_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_borrowings')

@app.route('/home/new_borrowings/reject/<int:Borrowing_ID>')
def reject_borrowing(Borrowing_ID):
    cur = db.connection.cursor()
    cur.execute("DELETE FROM `Borrowing` WHERE `Borrowing_ID`=%s", (Borrowing_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_borrowings')

@app.route("/home/new_reservations")
def new_reservations():
    School_ID=session['School_ID']
    cur = db.connection.cursor()
    cur.execute("SELECT r.Reservation_ID, r.Book_ID, bk.Title, u.Username, u.Name, u.Surname, r.Request_Date FROM Reservation r INNER JOIN User u ON r.User_ID = u.User_ID INNER JOIN Book bk ON r.Book_ID = bk.Book_ID WHERE u.School_ID = %s AND r.Status = 'On Hold';", (School_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("new_reservations.html", pageTitle="New Reservations", results=results)

@app.route("/home/new_reservations/accept/<int:Reservation_ID>")
def accept_reservation(Reservation_ID):
    cur = db.connection.cursor()
    cur.execute("UPDATE `Reservation` SET `Status`='Approved' WHERE `Reservation_ID`=%s", (Reservation_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_reservations')

@app.route('/home/new_reservations/reject/<int:Reservation_ID>')
def reject_reservation(Reservation_ID):
    cur = db.connection.cursor()
    cur.execute("DELETE FROM `Reservation` WHERE `Reservation_ID`=%s", (Reservation_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_reservations')

@app.route("/home/new_reviews")
def new_reviews():
    School_ID=session['School_ID']
    cur = db.connection.cursor()
    cur.execute("SELECT rv.Review_ID, rv.Book_ID, bk.Title, u.Username, u.Name, u.Surname, rv.Rating, rv.Review_Text FROM Review rv INNER JOIN User u ON rv.User_ID = u.User_ID INNER JOIN Book bk ON rv.Book_ID = bk.Book_ID WHERE u.School_ID = %s AND rv.Status = 'On Hold';", (School_ID,))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("new_reviews.html", pageTitle="New Reviews", results=results)

@app.route("/home/new_reviews/accept/<int:Review_ID>")
def accept_review(Review_ID):
    cur = db.connection.cursor()
    cur.execute("UPDATE `Review` SET `Status`='Approved' WHERE `Review_ID`=%s", (Review_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_reviews')

@app.route('/home/new_reviews/reject/<int:Review_ID>')
def reject_review(Review_ID):
    cur = db.connection.cursor()
    cur.execute("DELETE FROM `Review` WHERE `Review_ID`=%s", (Review_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/new_reviews')

@app.route("/home/books")
def books():
    return render_template("books.html", pageTitle="Books In Library")

@app.route("/home/books/search",  methods=['POST'])
def books_search():
    School_ID=session['School_ID']
    role=session['User_Type']
    Option=request.form['Option']
    Input=request.form['Input']
    cur = db.connection.cursor()
    if role == 'Administrator' and Option == 'All':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID GROUP BY b.Book_ID;")
    elif role != 'Administrator' and Option == 'All':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE b.School_ID=%s GROUP BY b.Book_ID;", (School_ID,))
    elif role == 'Administrator' and Option == 'Title':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE b.Title LIKE %s GROUP BY b.Book_ID;", ('%'+Input+'%',))
    elif role != 'Administrator' and Option == 'Title':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE b.School_ID=%s AND b.Title LIKE %s GROUP BY b.Book_ID;", (School_ID, '%'+Input+'%'))
    elif role == 'Administrator' and Option == 'Category':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID JOIN Book_Category bc ON b.Book_ID = bc.Book_ID JOIN Category c ON bc.Category_ID = c.Category_ID WHERE c.Category_Name LIKE %s GROUP BY b.Book_ID;", ('%'+Input+'%',))
    elif role != 'Administrator' and Option == 'Category':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID JOIN Book_Category bc ON b.Book_ID = bc.Book_ID JOIN Category c ON bc.Category_ID = c.Category_ID WHERE b.School_ID=%s AND c.Category_Name LIKE %s GROUP BY b.Book_ID;", (School_ID, '%'+Input+'%'))
    elif role == 'Administrator' and Option == 'Author Surname':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE a.Author_Surname LIKE %s GROUP BY b.Book_ID;", ('%'+Input+'%',))
    elif role != 'Administrator' and Option == 'Author Surname':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE b.School_ID=%s AND a.Author_Surname LIKE %s GROUP BY b.Book_ID;", (School_ID, '%'+Input+'%'))
    elif role == 'Administrator' and Option == 'Available Copies':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE b.Available_Copies >= %s GROUP BY b.Book_ID;", (Input,))
    elif role != 'Administrator' and Option == 'Available Copies':
        cur.execute("SELECT b.Book_ID, b.Title, GROUP_CONCAT(CONCAT(a.Author_Name, ' ', a.Author_Surname) SEPARATOR ', ') AS Authors, b.Pages, b.Available_Copies, b.Inventory FROM Book b JOIN Book_Author ba ON b.Book_ID = ba.Book_ID JOIN Author a ON ba.Author_ID = a.Author_ID WHERE b.Available_Copies >= %s AND b.School_ID=%s GROUP BY b.Book_ID;", (Input, School_ID))
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("result_book.html", pageTitle="Books In Library", role=role, results=results)

@app.route("/home/books/search/update/<int:Book_ID>", methods=["GET", "POST"])
def update_book(Book_ID):
    if request.method == "GET":
        cur = db.connection.cursor()
        cur.execute("Select * FROM `Book` WHERE `Book_ID`=%s", (Book_ID,))
        result = cur.fetchone()
        cur.close()
        return render_template("book_update.html", result=result, pageTitle="Update Book")
    else:
        ISBN=request.form['ISBN']
        Title=request.form['Title']
        Publisher=request.form['Publisher']
        Available_Copies=request.form['Available Copies']
        Language=request.form['Language']
        Inventory=request.form['Inventory']
        cur = db.connection.cursor()
        cur.execute("UPDATE `Book` SET `ISBN`=%s, `Title`=%s, `Publisher`=%s, `Available_Copies`=%s, `Language`=%s, `Inventory`=%s WHERE `Book_ID`=%s", (ISBN, Title, Publisher, Available_Copies, Language, Inventory, Book_ID))
        db.connection.commit()
        cur.close()
        return redirect('/home/books')
    
@app.route("/home/books/search/delete/<int:Book_ID>")
def delete_book(Book_ID):
    cur = db.connection.cursor()
    cur.execute("DELETE FROM `Borrowing` WHERE `Book_ID`=%s", (Book_ID,))
    db.connection.commit()
    cur.execute("DELETE FROM `Reservation` WHERE `Book_ID`=%s", (Book_ID,))
    db.connection.commit()
    cur.execute("DELETE FROM `Review` WHERE `Book_ID`=%s", (Book_ID,))
    db.connection.commit()
    cur.execute("DELETE FROM `Book_Author` WHERE `Book_ID`=%s", (Book_ID,))
    db.connection.commit()
    cur.execute("DELETE FROM `Book_Category` WHERE `Book_ID`=%s", (Book_ID,))
    db.connection.commit()
    cur.execute("DELETE FROM `Book` WHERE `Book_ID`=%s", (Book_ID,))
    db.connection.commit()
    cur.close()
    return redirect('/home/books')

@app.route("/home/books/search/add", methods=["GET", "POST"])
def add_book():
    if request.method == "GET":
        cur = db.connection.cursor()
        cur.execute("SELECT * FROM `Category`")
        column_names = [i[0] for i in cur.description]
        categories = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
        cur.execute("SELECT * FROM `Author`")
        column_names = [i[0] for i in cur.description]
        authors = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
        cur.close()
        return render_template("book_add.html",  pageTitle="Add Book", categories=categories, authors=authors)
    else:
        School_ID=session['School_ID']
        ISBN=request.form['ISBN']
        Title=request.form['Title']
        Publisher=request.form['Publisher']
        Pages=request.form['Pages']
        Summary=request.form['Summary']
        Cover=request.form['Cover']
        Language=request.form['Language']
        Keywords=request.form['Keywords']
        Inventory=request.form['Inventory']
        Category=request.form['Category']
        Author_ID=request.form['Author_ID']
        cur = db.connection.cursor()
        cur.execute("SELECT * FROM `Category` WHERE `Category_Name`=%s", (Category,))
        categ=cur.fetchone()
        Category_ID=categ[0]
        cur.execute("SELECT MAX(Book_ID) FROM `Book`")
        book=cur.fetchone()
        Book_ID=book[0]
        Book_ID=Book_ID+1
        cur.execute("INSERT INTO `Book` (`ISBN`, `School_ID`, `Title`, `Publisher`, `Pages`, `Summary`, `Cover`, `Language`, `Keywords`, `Inventory`)\
                     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (ISBN, School_ID, Title, Publisher, Pages, Summary, Cover, Language, Keywords, Inventory))
        db.connection.commit()
        cur.execute("INSERT INTO `Book_Category` (`Category_ID`, `Book_ID`) VALUES (%s, %s)", (Category_ID, Book_ID))
        db.connection.commit()
        cur.execute("INSERT INTO `Book_Author` (`Author_ID`, `Book_ID`) VALUES (%s, %s)", (Author_ID, Book_ID))
        db.connection.commit()
        cur.close()
        return redirect('/home/books')

@app.route("/home/books/search/borrow/<int:Book_ID>")
def borrow_book(Book_ID):
    User_ID=session['User_ID']
    cur = db.connection.cursor()
    cur.execute("INSERT INTO `Borrowing` (`Book_ID`, `User_ID`) VALUES (%s, %s)", (Book_ID, User_ID))
    db.connection.commit()
    cur.close()
    return redirect('/home/books')

@app.route("/home/books/search/reserve/<int:Book_ID>", methods=["GET", "POST"])
def reserve_book(Book_ID):
    if request.method == "GET":
        cur = db.connection.cursor()
        cur.execute("Select * FROM `Book` WHERE `Book_ID`=%s", (Book_ID,))
        result = cur.fetchone()
        cur.close()
        return render_template("reserve_request.html", pageTitle="Reserve Book", result=result)
    else:
        User_ID=session['User_ID']
        Request_Date=request.form['Request Date']
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `Reservation` (`Book_ID`, `User_ID`, `Request_Date`) VALUES (%s, %s, %s)", (Book_ID, User_ID, Request_Date))
        db.connection.commit()
        cur.close()
        return redirect('/home/books')
    

@app.route("/home/books/search/review/<int:Book_ID>", methods=["GET", "POST"])
def review_book(Book_ID):
    if request.method == "GET":
        cur = db.connection.cursor()
        cur.execute("Select * FROM `Book` WHERE `Book_ID`=%s", (Book_ID,))
        result = cur.fetchone()
        cur.close()
        return render_template("add_review.html", pageTitle="Review Book", result=result)
    else:
        User_ID=session['User_ID']
        Rating=request.form['Rating']
        Review_Text=request.form['Review Text']
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `Review` (`Book_ID`, `User_ID`, `Review_Text`, `Rating`) VALUES (%s, %s, %s, %s)", (Book_ID, User_ID, Review_Text, Rating))
        db.connection.commit()
        cur.close()
        return redirect('/home/books')
    

@app.route("/home/books/add_category", methods=["GET", "POST"])
def add_category():
    if request.method == "GET":
        return render_template("add_category.html", pageTitle="Add Category")
    else:
        Category=request.form['Category Name']
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `Category` (`Category_Name`) VALUES (%s)", (Category,))
        db.connection.commit()
        cur.close()
        return redirect('/home')
    

@app.route("/home/books/add_author", methods=["GET", "POST"])
def add_author():
    if request.method == "GET":
        return render_template("add_author.html", pageTitle="Add Author")
    else:
        Name=request.form['Author Name']
        Surname=request.form['Author Surname']
        cur = db.connection.cursor()
        cur.execute("INSERT INTO `Author` (`Author_Name`, `Author_Surname`) VALUES (%s, %s)", (Name, Surname))
        db.connection.commit()
        cur.close()
        return redirect('/home')
    
@app.route("/home/books/see_authors")
def see_authors():
    cur = db.connection.cursor()
    cur.execute("SELECT * FROM `Author`")
    column_names = [i[0] for i in cur.description]
    results = [dict(zip(column_names, entry)) for entry in cur.fetchall()]
    cur.close()
    return render_template("see_authors.html", pageTitle="See Authors", results=results)
