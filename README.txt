Instalation Guide:

1. Kατεβάστε το git repository πατώντας στο «Code» και μετά «Download ZIP».
2. Κάντε extract all σε έναν φάκελο της επιλογής σας (ενδεικτικά με όνομα «app»).
3. Χρησιμοποιώντας το XAMPP (Apache και MySQL activated), συνδεθείτε στο phpMyAdmin και δημιουργήστε μία νέα βάση με όνομα «library_db» (είναι πολύ σημαντικό να προσέξετε την ορθογραφία να είναι ακριβής).
4. Ανοίξτε το terminal σας και εκτελέστε την εντολή: pip install -r requirements.txt
5. Όντας εντός της βάσης στο phpMyAdmin, πατήστε Import > Browse > app > SQL > DDL_and_DML.sql για να δημιουργήσετε την βάση. Στην συνέχεια, μέσω του φακέλου app, τρέξτε το αρχείο run.py, όπου θα σας εμφανιστεί το εξής παράθυρο με οδηγίες:

