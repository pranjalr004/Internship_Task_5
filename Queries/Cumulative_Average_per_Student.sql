WITH student_sem_avg AS (
    -- Compute each student's average grade per semester
    SELECT
        e.student_id,
        s.name          AS student_name,
        e.semester,
        ROUND(AVG(e.grade), 2) AS sem_avg
    FROM enrollments e
    JOIN students s ON s.id = e.student_id
    GROUP BY e.student_id, s.name, e.semester
)
SELECT
    student_name,
    semester,
    sem_avg AS semester_avg,
    ROUND(
        AVG(sem_avg) OVER (
            PARTITION BY student_name
            ORDER BY semester
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    , 2) AS running_avg
FROM student_sem_avg
ORDER BY student_name, semester;
