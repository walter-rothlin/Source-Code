
# Install driver first: python -m pip install mysql-connector-python
import mysql.connector  # mysql-connector-python not default mässiger one


print("Connecting to sakila....", end="", flush=True)
db_connection = mysql.connector.connect(
  host        = "localhost",
  user        = "BWI-A24",   # "root",
  password    = "HWZ-2026", #"admin",
  database    = "sakila",
  auth_plugin = 'mysql_native_password'
)
print("completed!")

search_string = input("Enter search string for city (e.g. 'Al'): ")
case_sensitive = input("Should the search be case-sensitive? (y/n): ").strip().lower() == 'y'
if case_sensitive:
  ort_search_sql = f"SELECT * FROM `city_country` WHERE `Stadt` LIKE BINARY '{search_string}%';"
else:
  ort_search_sql = f"SELECT * FROM `city_country` WHERE `Stadt` LIKE '{search_string}%';"

print(f"Executing SQL: {ort_search_sql}")

my_cursor = db_connection.cursor(dictionary=True)
my_cursor.execute(ort_search_sql)
result_set = my_cursor.fetchall()
print(f'Tuples found: {len(result_set)}')
for a_tuple in result_set:
  print(a_tuple)

# print(result_set[1]['country_id'])




