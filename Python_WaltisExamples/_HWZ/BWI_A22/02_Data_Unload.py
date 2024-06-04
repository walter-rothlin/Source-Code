#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 02_Data_Unload.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HWZ/BWI_A22/02_Data_Unload.py
#
# Description: Connects to sakila and unloads Data from tables
#
# Autor: Walter Rothlin
#
# History:
# 04-Jun-2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
import mysql.connector
import datetime


def getTimestamp(preStr="", postStr="", formatString="nice"):
  """
      formatString == nice    ==> {ts:%Y-%m-%d %H:%M:%S}   2021-01-02 13:15:03
      formatString == Default ==> {ts:%Y%m%d%H%M%S}        20210102131503

      %a 	Weekday, short version 	Wed
      %A 	Weekday, full version 	Wednesday
      %w 	Weekday as a number 0-6, 0 is Sunday 	3
      %d 	Day of month 01-31 	31
      %b 	Month name, short version 	Dec
      %B 	Month name, full version 	December
      %m 	Month as a number 01-12 	12
      %y 	Year, short version, without century 	18
      %Y 	Year, full version 	2018
      %H 	Hour 00-23 	17
      %I 	Hour 00-12 	05
      %p 	AM/PM 	PM
      %M 	Minute 00-59 	41
      %S 	Second 00-59 	08
      %f 	Microsecond 000000-999999 	548513
      %z 	UTC offset 	+0100
      %Z 	Timezone 	CST
      %j 	Day number of year 001-366 	365
      %U 	Week number of year, Sunday as the first day of week, 00-53 	52
      %W 	Week number of year, Monday as the first day of week, 00-53 	52
      %c 	Local version of date and time 	Mon Dec 31 17:41:00 2018
      %x 	Local version of date 	12/31/18
      %X 	Local version of time 	17:41:00
      %% 	A % character 	%
      %G 	ISO 8601 year 	2018
      %u 	ISO 8601 weekday (1-7) 	1
      %V 	ISO 8601 weeknumber (01-53) 	01
  """
  formatStr = '{ts:%Y-%m-%d %H:%M:%S}'
  if (formatString == ""):
    formatStr = '{ts:%Y%m%d%H%M%S}'
  elif (formatString == "nice"):
    formatStr = '{ts:%Y-%m-%d %H:%M:%S}'
  else:
    formatStr = formatString
  retStr = formatStr.format(ts=datetime.datetime.now())
  # retStr = left(retStr,len(retStr)-2)
  return preStr + retStr + postStr

def create_insert_data_stmt(db_schema, table_name, where_clause=None):
  my_cursor = db_schema.cursor(dictionary=True)

  if where_clause is None:
    where_clause = ''
  else:
    where_clause = f' WHERE {where_clause}'

  select_statement = f'SELECT * FROM `{table_name}`{where_clause};'

  my_cursor.execute(select_statement)
  result_set = my_cursor.fetchall()
  count_of_records = len(result_set)

  if count_of_records > 0:
    attribute_list = list(result_set[0].keys())
    attributes = str(attribute_list).replace('[', '').replace(']', '').replace("'", '`')
    ret_str = f'''
    INSERT INTO `{table_name}` ({attributes}) VALUES'''

    insert_tuple_str = ''
    for a_tuple in result_set:
      a_tuple_str = '        ('
      for a_attr in attribute_list:
        value_of_attr = a_tuple[a_attr]
        type_of_attr = type(value_of_attr)
        # print(f'{a_attr}={value_of_attr}  [{type_of_attr}]')
        if isinstance(value_of_attr, datetime.datetime):
          a_tuple_str += f"STR_TO_DATE('{value_of_attr}', '%Y-%m-%d %H:%i:%s')" + ', '

        elif isinstance(value_of_attr, datetime.date):
          a_tuple_str += f"STR_TO_DATE('{value_of_attr}', '%Y-%m-%d')" + ', '

        elif isinstance(value_of_attr, set):
          value_of_attr = str(value_of_attr)
          if value_of_attr == 'set()':
            # print(value_of_attr)
            a_tuple_str += 'NULL'  + ', '
          else:
            value_of_attr = value_of_attr.replace("', '", ",")
            value_of_attr = value_of_attr[:-2]  # .replace(r"'{", "")
            value_of_attr = value_of_attr[2:]  # .replace(r"}'", "")
            a_tuple_str += f"'{value_of_attr}'" + ', '

        elif isinstance(value_of_attr, str):
          a_tuple_str += f"'{value_of_attr}'" + ', '

        elif value_of_attr is None:
          a_tuple_str += 'NULL' + ', '

        else:
          a_tuple_str += f"{value_of_attr}" + ', '

      a_tuple_str = a_tuple_str[:-2]
      a_tuple_str += '),'
      insert_tuple_str += '\n' + a_tuple_str
    insert_tuple_str = insert_tuple_str[:-1]
    # print(insert_tuple_str)
    ret_str += insert_tuple_str + ';'
  else:
    ret_str = f' -- WARNING: Table `{table_name}` is empty!'

  return f'''
    -- -------------------------------
    -- {select_statement}   --> {count_of_records} records found
    -- Extracted at: {getTimestamp()}{ret_str}
      
  '''


if __name__ == '__main__':
  connection_properties_HWZ_2024 = {
    'host': 'localhost',
    'user': 'Test_APP_2024',
    'password': 'BWI-A22',
    'database': 'HWZ_2024',
    'auth_plugin': 'mysql_native_password',
  }

  connection_properties_sakila = {
    'host': 'localhost',
    'user': 'root',
    'password': 'admin',
    'database': 'sakila',
    'auth_plugin': 'mysql_native_password',
  }


  connection_properties = connection_properties_sakila
  print(f"Connecting to '{connection_properties['database']}'@{connection_properties['host']}....", end="", flush=True)
  mydb = mysql.connector.connect(
    host        = connection_properties['host'],
    user        = connection_properties['user'],
    password    = connection_properties['password'],
    database    = connection_properties['database'],
    auth_plugin = connection_properties['auth_plugin']
  )
  print("completed!")

  insert_stmt = ''
  single_insert_stmt = create_insert_data_stmt(mydb, 'country', where_clause="`country` = 'Algeria'")
  insert_stmt += '\n' + single_insert_stmt

  single_insert_stmt = create_insert_data_stmt(mydb, 'language', where_clause=None)
  insert_stmt += '\n' + single_insert_stmt

  single_insert_stmt = create_insert_data_stmt(mydb, 'film', where_clause="`title` LIKE 'AC%'")
  insert_stmt += '\n' + single_insert_stmt

  insert_stmt = f'''
  SET FOREIGN_KEY_CHECKS = 0;
  {insert_stmt}
  SET FOREIGN_KEY_CHECKS = 1;
  '''
  # print(insert_stmt)
  filename = './insert.sql'
  with open(filename, 'w', encoding="utf-8") as file:
    file.write(insert_stmt)
  print(f'---> Insert written into {filename}')
