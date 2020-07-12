##Postgres: Assume you have a table with an identifier column and values for each id and assume you want to select the top 3 highest values for each id.

CREATE TABLE dense_rank_example (
	id INTEGER,
  val INTEGER
);
insert into dense_rank_example values (0,1),(0,2),(0,2),(0,4),(0,5),(1,1),(1,2),(1,3),(1,4),(1,5),(2,1),(2,2),(2,3),(2,4),(2,5)

with data_with_row_nums as
(
select *, row_number () OVER ( 
		PARTITION BY id
		ORDER BY val DESC
	) as row_num  from dense_rank_example
)
select * from data_with_row_nums where row_num < 4
