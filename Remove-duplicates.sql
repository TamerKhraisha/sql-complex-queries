-- Say you have a table where col1 and col2 have multiple equal rows and assume that col1 is a primary key or the main column

with table_with_row_number as
(
SELECT col1,col2,ROW_NUMBER() OVER(PARTITION by col2, col2 ORDER BY col1) 
AS row_num
FROM table
)
select * from table_with_row_number where row_num=1
