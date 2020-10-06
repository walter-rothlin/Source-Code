
import json
import requests

# see https://realpython.com/python-json/

# Original response = requests.get("https://jsonplaceholder.typicode.com/todos")
response = requests.get("https://jsonplaceholder.typicode.com/todos")
todos = json.loads(response.text)
expectedAnswer = [
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": False
  },
  {
    "userId": 1,
    "id": 2,
    "title": "quis ut nam facilis et officia qui",
    "completed": False
  },
  {
    "userId": 1,
    "id": 3,
    "title": "fugiat veniam minus",
    "completed": True
  },
  {
    "userId": 1,
    "id": 4,
    "title": "et porro tempora",
    "completed": True
  }
]

# Zugriff auf bestimmte Daten-Elemente
print(todos)
print(todos[0])   # 1.Array-Element (Beginnt mit Element 0)
print(todos[1]["title"])   # Vom 2.Array-Element der Wert mit key "title"
print(todos[2]["completed"])   # Vom 2.Array-Element der Wert mit key "completed"
print(todos[3]["completed"])   # Vom 3.Array-Element der Wert mit key "completed"
if todos[2]["completed"]:
    print("toDo[2] is completed!")
else:
    print("toDo[2] is NOT completed!")
if todos[3]["completed"]:
    print("toDo[3] is completed!")
else:
    print("toDo[3] is NOT completed!")

# Length of array
print(len(todos))

# Alle Keys from Dict
for c in todos[4]:
    print("Key:", c, "    Value:", todos[4][c])

# foreach aToDo in todos:
for i in range(len(todos)):
    print(i, todos[i])

print("--Sub Listen")
subToDos = todos[4:6]
print("len(subToDos):", len(subToDos))
