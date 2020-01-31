CREATE TABLE test
(
id int,
number int
);

INSERT INTO test
	(id, number)
VALUES
	(1, 10),
	(2, 12),
	(3, 3),
	(4, 15),
	(5, 23);
SELECT t1.id,
       t1.number,
       SUM(t2.number) AS CUM_SUM
FROM test t1
INNER JOIN test t2 ON t1.id >= t2.id
GROUP BY t1.id,
         t1.number
ORDER BY t1.id
