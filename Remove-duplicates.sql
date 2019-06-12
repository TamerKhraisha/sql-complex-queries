
with distinct_g_funda_gvkeys as
(
SELECT gvkey,iid,ROW_NUMBER() OVER(PARTITION by gvkey, iid ORDER BY gvkey) 
AS row_num
FROM g_funda
)
select * from distinct_g_funda_gvkeys where row_num=1
