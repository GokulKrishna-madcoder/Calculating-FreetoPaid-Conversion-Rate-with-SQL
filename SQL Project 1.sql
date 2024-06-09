SELECT 
    ROUND(COUNT(a.first_date_purchased) / COUNT(a.student_id) * 100, 2) AS conversion_rate,
    ROUND(SUM(a.date_diff_reg_watch) / COUNT(a.student_id), 2) AS av_reg_watch,
    ROUND(SUM(a.date_diff_watch_purch) / COUNT(a.student_id), 2) AS av_watch_purch
FROM
    (
        SELECT 
            si.student_id, 
            si.date_registered, 
            MIN(se.date_watched) AS first_date_watched, 
            MIN(sp.date_purchased) AS first_date_purchased, 
            DATEDIFF(MIN(se.date_watched), si.date_registered) AS date_diff_reg_watch, 
            DATEDIFF(MIN(sp.date_purchased), MIN(se.date_watched)) AS date_diff_watch_purch
        FROM 
            student_info si
        LEFT JOIN 
            student_engagement se ON si.student_id = se.student_id
        LEFT JOIN 
            student_purchases sp ON si.student_id = sp.student_id
        GROUP BY 
            si.student_id, si.date_registered
    ) a;
    
SELECT 
    MIN(date_watched) AS first_date_watched
FROM 
    student_engagement
WHERE 
    student_id = 268727;

SELECT * from student_purchases;
    
SELECT
	MIN(date_purchased) AS first_date_purchased
FROM
	student_purchases
WHERE
	student_id=268727;

SELECT 
    ROUND(
        (SELECT COUNT(DISTINCT sp.student_id)
         FROM student_engagement se
         JOIN student_purchases sp ON se.student_id = sp.student_id) / 
        (SELECT COUNT(DISTINCT se.student_id)
         FROM student_engagement se) * 100) AS conversion_rate;

SELECT 
    AVG(DATEDIFF(sp.date_purchased, se.date_watched)) AS avg_duration
FROM 
    student_purchases sp
JOIN 
    student_engagement se ON se.student_id = sp.student_id;