#This query is written in Snowflake

select first_column, second_column,third_column,
case 
when third_column is not null then third_column
else lag(third_column,1) ignore nulls over (partition by first_column order by second_column asc)
end as new_column
from table_name

