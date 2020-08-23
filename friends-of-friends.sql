#Postgres 9.6
# The following query will select the friends of friends of person 1

CREATE TABLE friendships
(
link_id integer PRIMARY KEY,
person1_id integer,
person2_id integer
);

INSERT INTO friendships (link_id, person1_id, person2_id) VALUES (1,1,2),(2,2,3),(3,2,5),(4,2,6),(5,1,10),(6,1,8),(7,3,9),(8,4,6),(9,10,11),(10,8,13)

SELECT A.person2_id FROM friendships A
INNER JOIN friendships B
ON A.person1_id = B.person2_id
WHERE B.person1_id = 1



