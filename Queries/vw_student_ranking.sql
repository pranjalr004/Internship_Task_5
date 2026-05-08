CREATE OR REPLACE VIEW vw_student_ranking AS
WITH sc AS (
    SELECT
        e.course_id,
        e.student_id,
        ROUND(AVG(e.grade), 2) AS avg_grade
    FROM enrollments e
    GROUP BY e.course_id, e.student_id
),
r AS (
    SELECT
        sc.course_id,
        sc.student_id,
        sc.avg_grade,
        RANK() OVER (
            PARTITION BY sc.course_id
            ORDER BY sc.avg_grade DESC
        ) AS rnk
    FROM sc
)
SELECT
    c.name  AS course_name,
    s.name  AS student_name,
    r.avg_grade,
    r.rnk   AS rank_in_course
FROM r
JOIN students s ON s.id = r.student_id
JOIN courses  c ON c.id = r.course_id;

-- Test the view
SELECT * FROM vw_student_ranking ORDER BY course_name, rank_in_course;