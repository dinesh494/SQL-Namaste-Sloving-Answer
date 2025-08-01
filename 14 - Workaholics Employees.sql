WITH cte AS(
SELECT
	emp_id,
    MAX(1) AS criterian
FROM
	employees
GROUP BY
	1
HAVING
	SUM(CASE WHEN TIMESTAMPDIFF(HOUR,login,logout) >= 8 THEN 1 ELSE 0 END) >= 3
UNION ALL
SELECT
	emp_id,
    MAX(2) AS criterian
FROM
	employees
GROUP BY
	1
HAVING
	SUM(CASE WHEN TIMESTAMPDIFF(HOUR,login,logout) >= 10 THEN 1 ELSE 0 END) >= 2
)
SELECT
	emp_id,
    CASE WHEN COUNT(criterian) > 1 THEN 'both' ELSE MAX(criterian) END as criterian
FROM
	cte
GROUP BY
	1
ORDER BY 
	1
  ;
