-- Query 1 --
SELECT u.full_name, e.title, e.city, e.start_date
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
JOIN Events e ON r.event_id = e.event_id
WHERE e.status = 'upcoming'
AND u.city = e.city
ORDER BY e.start_date;

-- Query 2 --
SELECT e.event_id, e.title, AVG(f.rating) AS avg_rating
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY avg_rating DESC;

-- Query 3 --
SELECT *
FROM Users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id
    FROM Registrations
    WHERE registration_date >= CURDATE() - INTERVAL 90 DAY
);

-- Query 4 --
SELECT e.title,
(
 SELECT COUNT(*)
 FROM Sessions s
 WHERE s.event_id=e.event_id
 AND HOUR(s.start_time) BETWEEN 10 AND 12
) AS total_sessions
FROM Events e;

-- Query 5 --
SELECT city,
COUNT(*) total_users
FROM
(
   SELECT DISTINCT u.city,r.user_id
   FROM Users u
   JOIN Registrations r
   ON u.user_id=r.user_id
)t
GROUP BY city
ORDER BY total_users DESC
LIMIT 5;

-- Query 6 --
SELECT e.title,
SUM(resource_type='pdf') pdfs,
SUM(resource_type='image') images,
SUM(resource_type='link') links
FROM Events e
LEFT JOIN Resources r
ON e.event_id=r.event_id
GROUP BY e.event_id;

-- Query 7 --
SELECT full_name,
comments,
title
FROM Users
JOIN Feedback USING(user_id)
JOIN Events USING(event_id)
WHERE rating<3;

-- Query 8 --
SELECT e.title,
IFNULL(
(
SELECT COUNT(*)
FROM Sessions s
WHERE s.event_id=e.event_id
),0) session_count
FROM Events e
WHERE e.status='upcoming';

-- Query 9 --
SELECT u.full_name,
SUM(status='upcoming') upcoming,
SUM(status='completed') completed,
SUM(status='cancelled') cancelled
FROM Users u
LEFT JOIN Events e
ON u.user_id=e.organizer_id
GROUP BY u.user_id;

-- Query 10 --
SELECT DISTINCT e.title
FROM Events e
WHERE EXISTS
(
  SELECT *
  FROM Registrations r
  WHERE r.event_id=e.event_id
)
AND NOT EXISTS
(
  SELECT *
  FROM Feedback f
  WHERE f.event_id=e.event_id
);

-- Query 11 --
SELECT registration_date,
COUNT(user_id)
FROM Users
GROUP BY registration_date
HAVING registration_date between '2024-12-01' and '2024-12-12';

-- Query 12 --
SELECT e.title
FROM Events e
JOIN Sessions s
ON e.event_id=s.event_id
GROUP BY e.event_id
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Query 13 --
SELECT city,
ROUND(AVG(rating),2) avg_rating
FROM Events
JOIN Feedback USING(event_id)
GROUP BY city;

-- Query 14 --
SELECT e.title,
COUNT(*) registrations
FROM Registrations r
INNER JOIN Events e
ON e.event_id=r.event_id
GROUP BY e.event_id
ORDER BY 2 DESC
LIMIT 3;

-- Query 15 --
SELECT A.event_id,
A.title,
B.title
FROM Sessions A
JOIN Sessions B
ON A.event_id=B.event_id
AND A.session_id<>B.session_id
AND A.start_time<B.end_time
AND A.end_time>B.start_time;

-- Query 16 --
SELECT *
FROM Users
WHERE registration_date>=CURDATE()-INTERVAL 30 DAY
AND user_id NOT IN
(
   SELECT user_id
   FROM Registrations
);

-- Query 17 --
SELECT speaker_name
FROM Sessions
GROUP BY speaker_name
HAVING COUNT(session_id)>1;

-- Query 18 --
SELECT title
FROM Events
WHERE event_id NOT IN
(
   SELECT DISTINCT event_id
   FROM Resources
);


-- Query 19 --
SELECT e.title,
COUNT(DISTINCT r.user_id) total_registrations,
ROUND(AVG(f.rating),2) avg_rating
FROM Events e
JOIN Registrations r
ON e.event_id=r.event_id
LEFT JOIN Feedback f
ON e.event_id=f.event_id
WHERE e.status='completed'
GROUP BY e.event_id;

-- Query 20 -- 
SELECT u.full_name,
IFNULL(r.events,0) attended,
IFNULL(f.feedbacks,0) feedbacks
FROM Users u
LEFT JOIN
(
   SELECT user_id,
   COUNT(*) events
   FROM Registrations
   GROUP BY user_id
) r
ON u.user_id=r.user_id
LEFT JOIN
(
   SELECT user_id,
   COUNT(*) feedbacks
   FROM Feedback
   GROUP BY user_id
) f
ON u.user_id=f.user_id;

-- Query 21 --
SELECT full_name,
COUNT(*) total_feedback
FROM Users
JOIN Feedback USING(user_id)
GROUP BY user_id
ORDER BY total_feedback DESC
LIMIT 5;


-- Query 22 -- 
SELECT user_id,
event_id
FROM Registrations
GROUP BY user_id,event_id
HAVING COUNT(*)>1;

-- Query 23 --
SELECT DATE_FORMAT(registration_date,'%Y-%m') month_year,
COUNT(*) registrations
FROM Registrations
GROUP BY DATE_FORMAT(registration_date,'%Y-%m');

-- Query 24 --
SELECT e.title,
ROUND(
AVG(
TIMESTAMPDIFF(MINUTE,start_time,end_time)
),2) avg_minutes
FROM Events e
JOIN Sessions s
ON e.event_id=s.event_id
GROUP BY e.event_id;

-- Query 25 --
SELECT title
FROM Events
WHERE event_id NOT IN
(
   SELECT DISTINCT event_id
   FROM Sessions
);