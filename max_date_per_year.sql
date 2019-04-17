#Snowflake. Select the maximum date within each month. id_column is an identifier of different data items

select id_column,max(date_column)
from co_adjfact
group by id_column,year(date_column)
