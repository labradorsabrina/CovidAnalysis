#pip3 install pypyodbc
import pypyodbc as odbc
import pandas as pd # pip install pandas

"""
Step 1. Importing dataset from CSV
"""
df = pd.read_csv('/Users/sabrina/Desktop/Covid/CovidDeaths.csv')

"""
Step 2.1 Data clean up
"""
df['Published Date'] = pd.to_datetime(df['Published Date']).dt.strftime('%Y-%m-%d %H:%M:%S')
df['Status Date'] = pd.to_datetime(df['Published Date']).dt.strftime('%Y-%m-%d %H:%M:%S')

df.drop(df.query('Location.isnull() | Status.isnull()').index, inplace=True)


"""
Step 2.2 Specify columns we want to import
"""
columns = ['Traffic Report ID', 'Published Date', 'Issue Reported', 'Location', 
            'Address', 'Status', 'Status Date']

df_data = df[columns]
records = df_data.values.tolist()


"""
Step 3.1 Create SQL Servre Connection String
"""
DRIVER = 'SQL Server'
SERVER_NAME = '<Server Name>'
DATABASE_NAME = '<Database Name>'

def connection_string(driver, server_name, database_name):
    conn_string = f"""
        DRIVER={{{driver}}};
        SERVER={server_name};
        DATABASE={database_name};
        Trust_Connection=yes;        
    """
    return conn_string

"""
Step 3.2 Create database connection instance
"""
try:
    conn = odbc.connect(connection_string(DRIVER, SERVER_NAME, DATABASE_NAME))
except odbc.DatabaseError as e:
    print('Database Error:')    
    print(str(e.value[1]))
except odbc.Error as e:
    print('Connection Error:')
    print(str(e.value[1]))


"""
Step 3.3 Create a cursor connection and insert records
"""

sql_insert = '''
    INSERT INTO Austin_Traffic_Incident 
    VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())
'''

try:
    cursor = conn.cursor()
    cursor.executemany(sql_insert, records)
    cursor.commit();    
except Exception as e:
    cursor.rollback()
    print(str(e[1]))
finally:
    print('Task is complete.')
    cursor.close()
    conn.close()