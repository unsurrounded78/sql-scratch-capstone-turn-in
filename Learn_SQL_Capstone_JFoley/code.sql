--Q1
--How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?

--How many distinct campaigns does CTS use?
SELECT COUNT(DISTINCT utm_campaign) AS 'CTS Campaigns'
FROM page_visits;

--How many distinct sources does CTS use?
SELECT COUNT(DISTINCT utm_source) AS 'CTS Sources'
FROM page_visits;

--How are campaigns related to sources?
SELECT DISTINCT utm_campaign AS 'Campaign', 
		utm_source AS 'Source'
FROM page_visits;


--Q2
--What pages are on the CoolTShirts website?

SELECT DISTINCT page_name AS 'Webpages'
FROM page_visits;


--Q3
--How many first touches is each campaign responsible for?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS '# First Touches'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--Q4
--How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS '# Last Touches'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;


--Q5
--How many visitors make a purchase?

SELECT COUNT(DISTINCT user_id) AS 'Visitors Who Purchase'
FROM page_visits
WHERE page_name = '4 - purchase';


--Q6
--How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS '# Last Touches'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

