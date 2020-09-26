
import json
import requests

# see https://realpython.com/python-json/

response = requests.get("https://jsonplaceholder.typicode.com/todos")
todos = json.loads(response.text)
print(todos)