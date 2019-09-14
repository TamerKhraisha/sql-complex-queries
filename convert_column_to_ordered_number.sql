#Assume you have a column called col1 and it has identifiers of some variable.
# You can assign a unique number to each identifier with the dense_rank() window function


dense_rank() over (order by col1) as col1_numeric,
