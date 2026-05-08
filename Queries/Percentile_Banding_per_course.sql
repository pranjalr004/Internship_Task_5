WITH
    course_scores AS (
        SELECT
            e.course_id,
            c.name AS course_name,
            e.student_id,
            s.name AS student_name,
            AVG(e.grade) AS avg_grade
        FROM
            enrollments e
            JOIN students s ON s.id = e.student_id
            JOIN courses c ON c.id = e.course_id
        GROUP BY
            e.course_id,
            c.name,
            e.student_id,
            s.name
    )
SELECT
    course_name,
    student_name,
    ROUND(avg_grade, 2) AS avg_grade,
    ROUND(
        PERCENT_RANK() OVER (
            PARTITION BY
                course_id
            ORDER BY avg_grade
        ),
        4
    ) AS pct_rank,
    NTILE(4) OVER (
        PARTITION BY
            course_id
        ORDER BY avg_grade
    ) AS quartile
FROM course_scores
ORDER BY course_name, pct_rank DESC;