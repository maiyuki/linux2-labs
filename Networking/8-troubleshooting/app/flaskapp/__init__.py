from flask import Flask
import pymysql.cursors

db_success = False
color_style = "red"
conn = False

def db_conn():
    global color_style
    global db_success

    try:
        conn = pymysql.connect(host="172.22.150.30", user="user", password="password", cursorclass=pymysql.cursors.DictCursor)
        with conn.cursor() as cursor:
            cursor.execute("SHOW databases")
            db_success = True
            color_style = "green"
    except:
        db_success = False
        color_style = "red"

app = Flask(__name__)

@app.route("/")
def get_connection():
    db_conn()

    return "<h1 style='color:{color}'>Connection to DB is {db}</h1>".format(color=color_style, db=db_success)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
