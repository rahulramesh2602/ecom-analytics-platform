import os
import pandas as pd
from sqlalchemy import create_engine
import argparse
import time

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    data_dir = params.data_dir

    # Create a connection engine to PostgreSQL
    try:
        engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
        print("Successfully connected to the PostgreSQL database.")
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return

    # Find all CSV files in the data directory
    csv_files = [f for f in os.listdir(data_dir) if f.endswith('.csv')]

    if not csv_files:
        print(f"No CSV files found in the directory: {data_dir}")
        return

    print(f"Found {len(csv_files)} CSV files to ingest.")

    for csv_file in csv_files:
        t_start = time.time()
        
        file_path = os.path.join(data_dir, csv_file)
        
        # Clean up the table name
        table_name = csv_file.replace('olist_', '').replace('_dataset.csv', '').replace('.csv', '')
        
        print(f"Processing {csv_file} -> Loading into table '{table_name}'...")

        # Read the CSV into a pandas DataFrame
        df = pd.read_csv(file_path)

        # Ingest the data into the PostgreSQL database
        try:
            df.to_sql(name=table_name, con=engine, if_exists='replace', index=False)
            t_end = time.time()
            print(f"Successfully loaded {len(df)} rows into '{table_name}' table in {t_end - t_start:.3f} seconds.\n")
        except Exception as e:
            print(f"Error loading data into '{table_name}': {e}\n")

    print("Data ingestion process completed.")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data into a PostgreSQL database.')

    # Add arguments for database connection
    parser.add_argument('--user', required=True, help='Username for PostgreSQL')
    parser.add_argument('--password', required=True, help='Password for PostgreSQL')
    parser.add_argument('--host', required=True, help='Host for PostgreSQL')
    parser.add_argument('--port', required=True, help='Port for PostgreSQL')
    parser.add_argument('--db', required=True, help='Database name for PostgreSQL')
    parser.add_argument('--data_dir', required=True, help='Directory containing the CSV files')
    
    args = parser.parse_args()
    
    main(args)
