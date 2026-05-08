CREATE TABLE if NOT exists students(
    id INT PRIMARY KEY,
    name VARCHAR(100),
    gender CHAR(1)
);

CREATE TABLE if NOT exists courses(
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE if NOT exists enrollments(
    id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade DECIMAL(5,2),
    semester VARCHAR(10)
);
