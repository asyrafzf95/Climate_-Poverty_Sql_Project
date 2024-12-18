![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Climate, Poverty, and Happiness Data Analysis Project

## Project Description

This project combines SQL and Python analysis to integrate and explore data related to climate, poverty, and global happiness. Three datasets (`climate`, `poverty`, `happiness`) were unified using a fourth auxiliary dataframe that links countries with unique indices. Subsequently, the data was cleaned, standardized, and uploaded to a SQL database using MySQL Workbench.

## Project Components

### Data:
- The original datasets (`climate_sql.csv`, `poverty_sql.csv`, `happiness_sql.csv`) are available in the `csv/` folder.
- An additional file (`country_id.csv`) contains the relationship between countries and the auxiliary index.

### Code:
- **`project.ipynb`**: A Python notebook used for:
  - Cleaning and standardizing country names using Regex.
  - Creating the auxiliary dataframe.
  - Generating new indexing columns.
  - Exporting and uploading data to MySQL Workbench.
- **`project_database.sql`**: Contains the SQL queries performed on the database, including:
  - Simple queries.
  - Using JOINS, CASE END UP, and subqueries for advanced analysis.

### Database:
- A database was created in MySQL Workbench, configured with primary and foreign keys to relate the tables. 
- A relational diagram (ERD) named `ERD.jpeg` is included.

## Requirements

- **Python** (version >= 3.8 recommended)
- Libraries:
  - `pandas`
  - `regex`
  - MySQL connector for Python (e.g., `mysql-connector-python`)
- **MySQL Workbench** for database creation and management.

## Steps to Reproduce the Project

1. **Data Preparation**:
   - Download the CSV files into the `data/` folder.
   - Open the `project.ipynb` file in a Jupyter Notebook environment (e.g., VS Code).
   - Run the cells to clean, standardize, and prepare the data for database upload.

2. **Database**:
   - Create a database in MySQL Workbench.
   - Use the Wizard tools to import the CSV files.
   - Configure primary and foreign keys as shown in the ERD diagram.

3. **SQL Queries**:
   - Open the `project_database.sql` file in MySQL Workbench and execute the queries.
