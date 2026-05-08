WITH course_sem_avg AS (
    -- CTE 1: Course-level average per semester
    SELECT
        e.course_id,
        c.name          AS course_name,
        e.semester,
        ROUND(AVG(e.grade), 2) AS course_avg
    FROM enrollments e
    JOIN courses c ON c.id = e.course_id
    GROUP BY e.course_id, c.name, e.semester
),
student_sem_avg AS (
    -- CTE 2: Student-level average per course per semester
    SELECT
        e.course_id,
        e.student_id,
        s.name          AS student_name,
        e.semester,
        ROUND(AVG(e.grade), 2) AS student_avg
    FROM enrollments e
    JOIN students s ON s.id = e.student_id
    GROUP BY e.course_id, e.student_id, s.name, e.semester
)
-- Final: Join both CTEs and compute delta
SELECT
    s.student_name,
    c.course_name,
    s.semester,
    s.student_avg,
    c.course_avg,
    ROUND(s.student_avg - c.course_avg, 2) AS delta_vs_course
FROM student_sem_avg  s
JOIN course_sem_avg   c
  ON c.course_id = s.course_id
 AND c.semester  = s.semester
ORDER BY c.course_name, s.semester, delta_vs_course DESC;