from flask import Flask
from flask import render_template
from flask import request
from flask import Flask



app = Flask(__name__)

@app.route('/')
def hello():
    return render_template("html.html")

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

app = Flask(__name__)

@app.route('/')
def hello():
    return render_template("html.html")

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')