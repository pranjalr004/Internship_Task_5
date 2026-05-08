CREATE OR REPLACE VIEW vw_course_stats AS
SELECT
    c.id             AS course_id,
    c.name           AS course_name,
    ROUND(AVG(e.grade), 2) AS avg_grade,
    MIN(e.grade)     AS min_grade,
    MAX(e.grade)     AS max_grade,
    COUNT(*)         AS total_enrollments
FROM enrollments e
JOIN courses c ON c.id = e.course_id
GROUP BY c.id, c.name;

-- Test the view
SELECT * FROM vw_course_stats ORDER BY avg_grade DESC;