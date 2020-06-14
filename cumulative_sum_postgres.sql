#POSTGRES
#Create a new column which is the cumulative sum of the total 


CREATE TABLE Queue ( id INTEGER, name VARCHAR(20), turn INTEGER, weight INTEGER )

INSERT INTO Queue 
    (id, name, turn, weight) 
VALUES
    (0, 'John', 1, 200),
    (1, 'Michael', 3, 240),
    (2, 'Tamer', 8, 400),
    (3, 'Morgan', 2, 300),
    (4, 'Witcher', 6, 600),
    (5, 'Fish', 5, 400),
    (6, 'Smith', 7, 250),
    (7, 'Paolo', 4, 100)

SELECT name, turn, weight, sum(weight) over (ORDER BY turn) as cum_sum
from Queue
