import requests
from flask import jsonify, Flask
from flask_crontab import Crontab

API_TOKEN = '3381c830a1eb4a692b197c573b3ea771760e9c76'
COMPANY_DOMAIN = 'dubbeltech2'

app = Flask(__name__)
crontab = Crontab(app)

gist_database = []
user_database = []
deal_url = f'https://{COMPANY_DOMAIN}.pipedrive.com/api/v1/deals?api_token={API_TOKEN}'


@app.route('/<string:username>', methods = ['GET'])
def get_gists(username):
  result = []
  deal = {}
  if username not in user_database:
    user_database.append(username)
  #url to request
  url = f"https://api.github.com/users/{username}/gists"
  gist_data = requests.get(url).json()


  for gist in gist_data:

    if gist["id"] not in gist_database:
        gist_database.append(gist["id"])
        deal['title'] = f"real estate sale #{gist['id']}"
        deal['org_id'] = 1
        requests.post(url= deal_url, data=deal)
        result.append(gist)

  return jsonify(result)


@app.route('/users', methods = ['GET'])
def get_users():
  
  return jsonify(user_database)

@app.route("/favicon.ico")
def favicon():
    return { "welcome": "supress it"}


@crontab.job(minute="1")
def my_scheduled_job():

    requests.get(f"127.0.0.1:8000/{user_database[-1]}").json()


if __name__ == "__main__":
     app.run(host="0.0.0.0", debug=True)