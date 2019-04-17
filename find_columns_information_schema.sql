#This query is written in Snowflake. It retreives all tables that contain specific columns
SELECT TABLE_NAME, COLUMN_NAME 
FROM DB.INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('column1','column2','column3')
