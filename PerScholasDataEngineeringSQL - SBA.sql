-- The Curriculum Planning Committee is attempting to fill in gaps in the current course offerings. You need to provide them with a query which lists each department and the number of courses offered by that department. The output should be sorted first by the Number of Courses in ascending order, then by Department Name in ascending order

select department.name, count(course.id)
from department
inner join course on department.id = course.deptid
group by department.name
order by count(course.id);

-- The recruiting department needs to know which courses are most popular with the students. Please provide them with a query which lists the name of each course and the number of students in that course. The output should be sorted by the Number of Students in descending order, then by Course Name in ascending order.

select course.name, count(studentCourse.studentID)
from course inner join studentCourse
on course.ID = studentcourse.courseID
group by course.name
order by count(studentCourse.studentID) desc, course.name;

-- Quite a few students have been complaining that the professors are absent from some of their courses. Write a query to list the names of all Courses where the number of faculty assigned to those courses is zero. The output should be sorted by Course Name in ascending alphabetical order

select course.name from course 
where ID not in (select courseID from facultyCourse)
order by course.name;

-- Quite a few students have been complaining that the professors are absent from some of their courses. Write a query to list the Course Names and the Number of Students in those courses for all courses where there are no assigned faculty. The output should be sorted first by the Number of Students in descending order, then by Course Name in ascending order

select course.name, count(studentCourse.studentID)
from course inner join studentCourse on course.ID = studentCourse.courseID
where course.ID not in (select courseID from facultyCourse)
group by course.name
order by count(studentCourse.studentID) desc, course.name;

-- The enrollment team is gathering analytics about student enrollment throughout the years. Write a query that lists the Total Number of Students that were enrolled in classes during each School Year. The first column should have the header "Students". Provide a second "Year" column showing the enrollment year. The output should be sorted first by the School Year in ascending order, then by Total Number of Students in descending order

select count(distinct(studentID)) as "Total Number of Students", year(startDate) as "Year" from studentCourse
group by year(startDate)
order by "Total Number of Students" desc;

-- The enrollment team is gathering analytics about student enrollment and they now want to know about August admissions specifically. Write a query that lists the Start Date and Total Number of Students who enrolled in classes in August of each year. The output should be ordered first by Start Date in ascending order and then by Total Number of Students in ascending order

select startDate as "Start Date", count(distinct(studentID)) as "Total Number of Students"
from studentCourse
where month(startDate) = "08"
group by startDate
order by startDate, count(distinct(studentID));

-- Students are required to take 4 courses, and atleast two of these courses must be from the department of their major. Write a query to list students First Name, Last Name and Number of Courses they are taking in their major department. The output should be sorted first by the Number of Courses in descending order, then by First Name in ascending order, then by the Last Name in ascending order

select student.firstName "First Name", student.lastName "Last Name", count(studentCourse.courseID) "Course Count" from student inner join studentCourse on (student.ID = studentCourse.studentID) inner join course on (studentCourse.courseID = course.ID)
where student.majorID = course.deptID
group by student.lastName, student.firstName
order by count(studentCourse.courseID) desc, student.firstName, student.lastName;

-- Students making average progress in their courses of less than 50% need to be offered tutoring assistance. Write a query to list First Name, Last Name and Average Progress of all students achieving average progress of less than 50%. The Average Progress displayed should be rounded to one decimal place. The output should be sorted first by Average Progress in descending order, then by First Name in ascending order, then by Last Name in ascending order.

select student.firstName "First Name", student.lastName "Last Name", round(avg(studentCourse.progress),1) "Average Progress" from student inner join studentCourse on (student.ID = studentCourse.studentID)
group by student.firstName, student.lastName
having round(avg(studentCourse.progress),1) < 50
order by round(avg(studentCourse.progress),1) desc, "First Name", "Last Name";

-- Faculty are awarded bonuses based on the progress made by students in their courses. Write a query that shows the Course Name and the Average Student Progress of the course with the highest Average Progress in the system. The Average Progress displayed should be rounded to one decimal place.

select course.name, max(avg(studentCourse.progress)) from course inner join studentCourse on (course.ID = studentCourse.courseID);

-- Faculty are awarded bonuses based on the progress made by students in their courses. Write a query that outputs the faculty First Name, Last Name and the Average Progress made over all of their courses. The Average Progress displayed should be rounded to one decimal place. The output should be sorted by Average Progress in descending order, then by First Name in ascending order, then by Last Name in ascending order

select student.firstName as "First Name", student.lastName as "Last Name", round(avg(studentCourse.progress),1) as "Average Progress" from student inner join studentCourse on student.id = studentCourse.studentID
group by student.firstName, student.lastName
order by round(avg(studentCourse.progress),1) desc;

-- Students are awarded two grades based on the minimum and maximum progress they are making in their courses. The grading scale is as follows:
-- Progress < 40: F
-- Progress < 50: D
-- Progress < 60: C
--Progress < 70: B
-- Progress >= 70: A
-- Write a query that displays each student's First Name, Last Name, Minimum Grade based on their minimum progress and Maximum Grade based on their maximum progress. The output should be sorted by Minimum Grade in descending order, the by Maximum Grade in descending order, then by First Name in ascending order, then by Last Name in ascending order

select student.firstName "First Name", student.lastName "Last Name", CASE
when min(studentCourse.progress) < 40 then "F"
when min(studentCourse.progress) < 50 then "D"
when min(studentCourse.progress) < 60 then "C"
when min(studentCourse.progress) < 70 then "B"
else "A"
end as Minimum_Grade, CASE
when max(studentCourse.progress) < 40 then "F"
when max(studentCourse.progress) < 50 then "D"
when max(studentCourse.progress) < 60 then "C"
when max(studentCourse.progress) < 70 then "B"
else "A"
end as Maximum_Grade
from student inner join studentCourse ON student.ID = studentCourse.studentID
group by student.firstName, student.lastName
order by Minimum_Grade desc, Maximum_Grade desc, student.firstName, student.lastName;