#POSTGRES

#Assume we have an elevator that has a max capacity of 1000kg. People are standing in line and each have an order in the line.
#Get the name of the last person that can fit in the elevator

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

with cumsum AS
(
select name, turn, weight, sum(weight) over (order by turn) as cum_sum
from Queue
)
select * from cumsum
where cum_sum <= 1000
order by turn DESC
limit 1
