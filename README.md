# Student Academic Performance Analysis - SQL Task

## Project Overview
This project contains a comprehensive SQL-based student academic performance analysis system. It includes database creation, table definitions, sample data insertion, and a collection of advanced SQL queries for analyzing student performance across multiple courses and semesters.

---

## Database Schema

### Tables

#### **students**
- `id` (INT, PRIMARY KEY): Unique student identifier
- `name` (VARCHAR(100)): Student's name
- `gender` (CHAR(1)): Student's gender (M/F)

#### **courses**
- `id` (INT, PRIMARY KEY): Unique course identifier
- `name` (VARCHAR(100)): Course name

#### **enrollments**
- `id` (INT, PRIMARY KEY): Unique enrollment record identifier
- `student_id` (INT): Reference to students table
- `course_id` (INT): Reference to courses table
- `grade` (DECIMAL(5,2)): Student's grade in the course
- `semester` (VARCHAR(10)): Semester identifier (format: YYYY-MM)

---

## Setup Instructions

### Step 1: Create Database
Execute the database creation script:
```sql
-- Database_Creation/Create_Database.sql
CREATE DATABASE students;
USE students;
```

### Step 2: Create Tables
Execute the table creation script:
```bash
-- Table_Creation/Tables.sql
-- Creates: students, courses, enrollments tables
```

### Step 3: Insert Sample Data
Execute the data insertion script:
```bash
-- Rows_Insertion/Rows.sql
-- Inserts 8 students, 3 courses, and 25 enrollment records
```

---

## Queries Documentation

### 1. **Top Performer Per Course** 
📁 File: `Queries/Top_Performer_per_course.sql`

**Purpose:** Identifies the top 3 performing students in each course based on their average grades.

**Key Features:**
- Uses CTE `student_course_avg` to calculate average grades per student per course
- Implements window function `RANK()` to rank students within each course
- Filters results to show only top 3 performers per course

**Query Breakdown:**
1. **Stage 1:** Calculate average grade for each student in each course
2. **Stage 2:** Rank students within their course by average grade (descending)
3. **Stage 3:** Select only those ranked in top 3

**Output Columns:**
- `course_name`: Name of the course
- `student_name`: Student's name
- `avg_grade`: Average grade (2 decimal places)
- `rank_in_course`: Ranking position (1-3)

**Use Case:** Identify high performers for recognition or course coordination

---

### 2. **Percentile Banding Per Course**
📁 File: `Queries/Percentile_Banding_per_course.sql`

**Purpose:** Analyzes student performance distribution within each course using percentile rankings and quartile banding.

**Key Features:**
- Uses `PERCENT_RANK()` window function to calculate percentile position (0 to 1)
- Uses `NTILE(4)` to band students into quartiles (1-4)
- Partitions analysis by course to provide course-specific insights

**Query Breakdown:**
1. Calculate average grade per student per course
2. Compute percentile rank: shows what percentage of students scored below each student
3. Assign quartile bands: divides students into 4 equal groups (Q1=lowest, Q4=highest)

**Output Columns:**
- `course_name`: Name of the course
- `student_name`: Student's name
- `avg_grade`: Average grade
- `pct_rank`: Percentile rank (0.0 = bottom, 1.0 = top)
- `quartile`: Quartile assignment (1-4)

**Use Case:** Understand performance distribution; identify struggling vs. excelling students

---

### 3. **Cumulative Average Per Student**
📁 File: `Queries/Cumulative_Average_per_Student.sql`

**Purpose:** Calculates running/cumulative average grades for each student across semesters, showing academic trend over time.

**Key Features:**
- Uses `AVG()` with window frame `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
- Computes running average that accumulates from the first semester to the current one
- Ordered by semester to show progression

**Query Breakdown:**
1. Calculate each student's average grade for each semester
2. Apply running window function to compute cumulative average across semesters
3. Display semester-by-semester progression with running average

**Output Columns:**
- `student_name`: Student's name
- `semester`: Semester identifier (YYYY-MM)
- `semester_avg`: Average grade for that specific semester
- `running_avg`: Cumulative average up to and including that semester

**Use Case:** Track student improvement over time; identify trends in academic performance

---

### 4. **CTE Chain - Student vs Course Average**
📁 File: `Queries/CTE_Chain.sql`

**Purpose:** Compares each student's performance against the course average, showing how much above or below the course mean each student performs.

**Key Features:**
- Demonstrates chaining of multiple CTEs
- Creates parallel CTEs: one for course averages, one for student averages
- Calculates delta (difference) between student and course performance
- Useful for comparative analysis

**Query Breakdown:**
1. **CTE 1 (course_sem_avg):** Calculate average grade for each course per semester
2. **CTE 2 (student_sem_avg):** Calculate average grade for each student per course per semester
3. **Final Join:** Join both CTEs and compute the performance delta

**Output Columns:**
- `student_name`: Student's name
- `course_name`: Course name
- `semester`: Semester identifier
- `student_avg`: Student's average in that course/semester
- `course_avg`: Course's overall average for that semester
- `delta_vs_course`: Difference (positive = above average, negative = below average)

**Use Case:** Identify students performing above/below their course peers; benchmark individual performance

---

### 5. **Reusable View - Course Statistics**
📁 File: `Queries/Reusable_View.sql`

**Purpose:** Creates a reusable view (`vw_course_stats`) that aggregates key statistics for each course.

**View Definition:**
```sql
CREATE OR REPLACE VIEW vw_course_stats AS
```

**Features:**
- Aggregates enrollment data by course
- Calculates multiple statistics in a single view
- Can be reused in multiple queries for efficiency

**Output Columns:**
- `course_id`: Unique course identifier
- `course_name`: Course name
- `avg_grade`: Average grade across all enrollments
- `min_grade`: Lowest grade in the course
- `max_grade`: Highest grade in the course
- `total_enrollments`: Number of enrollments in the course

**Use Case:** Quick reference for course performance metrics; basis for other analyses

**Sample Query:**
```sql
SELECT * FROM vw_course_stats ORDER BY avg_grade DESC;
```

---

### 6. **Student Ranking View**
📁 File: `Queries/vw_student_ranking.sql`

**Purpose:** Creates a reusable view (`vw_student_ranking`) that ranks students within each course based on average grade.

**View Definition:**
```sql
CREATE OR REPLACE VIEW vw_student_ranking AS
```

**Features:**
- Combines CTEs and window functions within a view
- Ranks students per course using `RANK()` window function
- Provides a convenient, reusable dataset for ranking queries

**Query Breakdown:**
1. **CTE sc:** Calculate average grade per student per course
2. **CTE r:** Rank students within each course by average grade (descending)
3. **Final Join:** Enrich with student and course names

**Output Columns:**
- `course_name`: Course name
- `student_name`: Student's name
- `avg_grade`: Average grade in that course
- `rank_in_course`: Ranking position (1 = highest performer)

**Use Case:** Quickly retrieve student rankings; basis for other ranking-based queries

**Sample Query:**
```sql
SELECT * FROM vw_student_ranking ORDER BY course_name, rank_in_course;
```

---

## Key SQL Concepts Used

### Window Functions
- **`RANK()`**: Assigns ranking with ties receiving same rank
- **`PERCENT_RANK()`**: Calculates percentile position (0 to 1)
- **`NTILE(n)`**: Divides rows into n equal groups
- **`AVG() OVER (... ROWS BETWEEN ...)`**: Calculates running/cumulative averages

### Common Table Expressions (CTEs)
- **Single CTEs**: Used to simplify complex queries
- **Multiple CTEs**: Chained CTEs for parallel data preparation
- **CTE in Views**: CTEs used within view definitions

### Aggregate Functions
- `AVG()`: Average value
- `MIN()`: Minimum value
- `MAX()`: Maximum value
- `COUNT()`: Count of rows

### Joins
- `INNER JOIN`: Combine related tables
- Demonstrated in all queries for data enrichment

---

## Sample Data Summary

**Students:** 8 students (Alice, Bob, Carol, David, Eva, Frank, Grace, Henry)

**Courses:** 3 courses (Mathematics, Physics, Computer Science)

**Data Periods:** 
- Semester 2024-01: Comprehensive data for all students
- Semester 2024-02: Partial data (for running average analysis)
- Semester 2025-01: Additional data (for trend analysis)

**Grade Range:** 55.0 to 95.0 (out of 100)

---

## Execution Order

For proper setup, execute files in this order:

1. `Database_Creation/Create_Database.sql` - Create database
2. `Table_Creation/Tables.sql` - Create tables
3. `Rows_Insertion/Rows.sql` - Insert sample data
4. `Queries/Reusable_View.sql` - Create views (optional but recommended)
5. Any of the other query files to analyze data

---

## Notes

- All grades are stored as DECIMAL(5,2) for precision
- Semester format is YYYY-MM (e.g., 2024-01)
- Views can be dropped and recreated safely using `CREATE OR REPLACE VIEW`
- All queries include comments for clarity
- Test queries are included at the end of view creation scripts

---

## Troubleshooting

**Issue:** Foreign key constraints
- Solution: Ensure tables are created before inserting data

**Issue:** Views reference non-existent tables
- Solution: Create tables and insert data before creating views

**Issue:** Window functions not working
- Solution: Ensure your MySQL version supports window functions (8.0+)

---

## Related Features

- **Advanced Analytics:** All queries demonstrate industry-standard SQL patterns
- **Scalability:** Queries designed to work efficiently with larger datasets
- **Reusability:** Views and CTEs enable code reuse and maintainability
