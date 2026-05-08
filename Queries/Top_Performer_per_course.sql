WITH student_course_avg AS (
    SELECT e.course_id,c.name AS course_name, e.student_id, s.name AS student_name, AVG(e.grade) AS avg_grade
    from enrollments e
    JOIN students s ON s.id=e.student_id
    JOIN courses c ON c.id=e.course_id
    GROUP BY e.course_id,c.name,e.student_id,s.name
),
ranked as (
SELECT
        course_id,
        course_name,
        student_name,
        ROUND(avg_grade, 2)  AS avg_grade,
        RANK() OVER (PARTITION BY course_id ORDER BY avg_grade DESC) AS rnk
    FROM student_course_avg
)

SELECT
    course_name,
    student_name,
    avg_grade,
    rnk AS rank_in_course
FROM ranked
WHERE rnk <= 3
ORDER BY course_name, rnk;