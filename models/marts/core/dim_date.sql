WITH base AS (
  {{ dbt_date.get_date_dimension("2015-01-01", "2030-12-31") }}
)

SELECT
{{ dbt_utils.generate_surrogate_key(['date_day']) }} as date_key,
  *,
  CASE
    WHEN month_of_year BETWEEN 9 AND 12 THEN 'first'
    WHEN month_of_year BETWEEN 1 AND 4 THEN 'second'
    ELSE 'third'
  END AS term
FROM base