import json
import pyodbc


CREDENTIALS_FILE = '/home/.azure/.sql-credentials'

with open(CREDENTIALS_FILE, 'r') as stream:
    CREDENTIALS = json.loads(stream.read())


server = CREDENTIALS['server']
database = CREDENTIALS['database']
username = CREDENTIALS['username']
password = CREDENTIALS['password']

driver = '{ODBC Driver 17 for SQL Server}'

connection_str = 'DRIVER='+driver+';SERVER=tcp:'+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password


def show_dbtables(cursor):
    print('== Showing tables ==')
    cursor.execute("select name from sys.tables")
    rows = cursor.fetchall()
    for row in rows:
        print(row)

def show_version(cursor):
    cursor.execute("SELECT @@version;") 
    row = cursor.fetchone() 
    while row: 
        print(row[0])
        row = cursor.fetchone()

def show_table(cursor, tablename):
    sql = 'SELECT TOP (10) * FROM [dbo].[' + tablename + ']'
    cursor.execute(sql)
    rows = cursor.fetchall()
    for row in rows:
        print(row)

def truncate_table(cursor, tablename):
    sql = 'truncate table ' + tablename
    cursor.execute(sql)

def custom_sql(cursor):
    sql = '[INSERT SQL HERE]'
    cursor.execute(sql)

with pyodbc.connect(connection_str, timeout=3) as conn:
    cursor = conn.cursor()
    show_version(cursor)
    # show_dbtables(cursor)
    show_table(cursor, 'bootcamp99_dim_clients')
    # truncate_table(cursor, '[INSERT TABLE NAME]')
    # custom_sql(cursor)