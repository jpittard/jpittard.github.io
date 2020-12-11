-- NTILE

select 
min(cnt) as tile_start,
max(cnt) as tile_end,
sum(cnt) as total_objects,
tile
from (select cnt, 
  ntile (20) over (order by cnt asc) as tile
  from tmp_object_count
)
group by tile
order by tile
;

-- Equal_width buckets

WITH
  dataset AS
  (
    SELECT
      cnt AS Analyzed_Column -- Date or numeric
    FROM
      tmp_object_count
  )
  ,
  MINMAX AS
  (
    SELECT
      MIN(Analyzed_Column) AS min_value,
      MAX(Analyzed_Column) AS Max_Value
    FROM
      dataset
  )
  ,
  buckets AS
  (
    SELECT
      Analyzed_Column,
      WIDTH_BUCKET(Analyzed_Column, MINMAX.min_value, MINMAX.max_value, 20) AS
      bucket
    FROM
      dataset,
      MINMAX
  )
  ,
  buckets_full AS
  (
    SELECT
      rownum AS bucket
    FROM
      (
        SELECT
          1 AS bucket_number
        FROM
          dual
          CONNECT BY LEVEL <= (20 + 1)
      )
  )
  ,
  buckets_analysis AS
  (
    SELECT
      bucket,
      MAX(Analyzed_Column) AS max_value,
      MIN(Analyzed_Column) AS min_value,
      COUNT(1)         AS COUNT
    FROM
      buckets
    GROUP BY
      bucket
  )
SELECT
  buckets_full.bucket,
  buckets_analysis.max_value,
  buckets_analysis.min_value,
  buckets_analysis.count
FROM
  buckets_full
LEFT OUTER JOIN buckets_analysis
ON
  buckets_full.bucket = buckets_analysis.bucket
ORDER BY buckets_full.bucket;
