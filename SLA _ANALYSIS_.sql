CREATE DATABASE technical_support_project;
USE technical_support_project;

SELECT DATABASE();
show tables;
SELECT COUNT(*) AS total_tickets
FROM technical_support_full_2330;

SELECT COUNT(*) AS open_tickets
FROM open_tickets;

CREATE OR REPLACE VIEW technical_support_all AS
SELECT * FROM technical_support_full_2330
UNION ALL
SELECT * FROM open_tickets;

SELECT COUNT(*) AS total_tickets
FROM technical_support_all;

-- Status--
SELECT Status, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Status
ORDER BY ticket_count DESC;


SELECT Priority, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Priority
ORDER BY ticket_count DESC;

SELECT Source, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Source
ORDER BY ticket_count DESC;

SELECT Topic, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Topic
ORDER BY ticket_count DESC;

-- Overall Resolution SLA--

SELECT `SLA For Resolution`, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY `SLA For Resolution`;

-- Overall First Response SLA--

SELECT `SLA For first response`, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY `SLA For first response`;

-- Priority-wise SLA--

SELECT Priority, `SLA For Resolution`, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Priority, `SLA For Resolution`;

-- Topic-wise SLA--

SELECT Topic, `SLA For Resolution`, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Topic, `SLA For Resolution`;

-- TIME ANALYSIS 
-- Average Resolution Time

SELECT ROUND(
    AVG(TIMESTAMPDIFF(MINUTE, `Created time`, `Resolution time`)) / 60,
    2
) AS average_resolution_hours
FROM technical_support_all
WHERE `Resolution time` IS NOT NULL;


-- Average First Response Time

SELECT ROUND(
    AVG(TIMESTAMPDIFF(MINUTE, `Created time`, `First response time`)) / 60,
    2
) AS average_first_response_hours
FROM technical_support_all
WHERE `First response time` IS NOT NULL;

-- GROUP BY 


-- Priority-wise Average Resolution

SELECT Priority,
       ROUND(AVG(`Resolution Hours`), 2) AS avg_resolution_hours
FROM technical_support_all
GROUP BY Priority;


-- Topic-wise Average Resolution

SELECT Topic,
       ROUND(AVG(`Resolution Hours`), 2) AS avg_resolution_hours
FROM technical_support_all
GROUP BY Topic
ORDER BY avg_resolution_hours DESC;


-- Product Group-wise Average Resolution
SELECT `Product group`,
       ROUND(AVG(`Resolution Hours`), 2) AS avg_resolution_hours
FROM technical_support_all
GROUP BY `Product group`
ORDER BY avg_resolution_hours DESC;


-- MONTHLY ANALYSIS

-- Monthly Resolution SLA

SELECT MONTH(`Created time`) AS month_number,
       `SLA For Resolution`,
       COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY MONTH(`Created time`), `SLA For Resolution`
ORDER BY month_number;


-- OPEN TICKETS ⭐

------ Open ticket count


SELECT COUNT(*) AS open_tickets
FROM technical_support_all
WHERE Status = 'Open';


---- Open ticket details
SELECT *
FROM technical_support_all
WHERE Status = 'Open';

SELECT `Ticket ID`, COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY `Ticket ID`
HAVING COUNT(*) > 1;


SELECT COUNT(*) AS total_tickets
FROM technical_support_all;

DESCRIBE technical_support_all;

SELECT 
    `Created time`,
    `First response time`,
    `Resolution time`
FROM technical_support_all
LIMIT 5;

-- Overall Resolution SLA
SELECT `SLA For Resolution`,
       COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY `SLA For Resolution`;


--  Resolution SLA by Priority
SELECT Priority,
       `SLA For Resolution`,
       COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Priority, `SLA For Resolution`
ORDER BY Priority;


--  Resolution SLA by Topic
SELECT Topic,
       `SLA For Resolution`,
       COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY Topic, `SLA For Resolution`
ORDER BY Topic;


--  Average Resolution Time
SELECT ROUND(
    AVG(
        TIMESTAMPDIFF(
            SECOND,
            STR_TO_DATE(LEFT(`Created time`,19), '%Y-%m-%d %H:%i:%s'),
            STR_TO_DATE(LEFT(`Resolution time`,19), '%Y-%m-%d %H:%i:%s')
        )
    ) / 3600,
    2
) AS average_resolution_hours
FROM technical_support_all
WHERE `Resolution time` <> CONCAT(CHAR(92), 'N');


-- Average First Response Time
SELECT ROUND(
    AVG(
        TIMESTAMPDIFF(
            SECOND,
            STR_TO_DATE(LEFT(`Created time`,19), '%Y-%m-%d %H:%i:%s'),
            STR_TO_DATE(LEFT(`First response time`,19), '%Y-%m-%d %H:%i:%s')
        )
    ) / 3600,
    2
) AS average_first_response_hours
FROM technical_support_all
WHERE `First response time` <> CONCAT(CHAR(92), 'N');


-- Average Resolution Time by Topic
SELECT Topic,
       ROUND(
           AVG(
               TIMESTAMPDIFF(
                   SECOND,
                   STR_TO_DATE(LEFT(`Created time`,19), '%Y-%m-%d %H:%i:%s'),
                   STR_TO_DATE(LEFT(`Resolution time`,19), '%Y-%m-%d %H:%i:%s')
               )
           ) / 3600,
           2
       ) AS avg_resolution_hours
FROM technical_support_all
WHERE `Resolution time` <> CONCAT(CHAR(92), 'N')
GROUP BY Topic
ORDER BY avg_resolution_hours DESC;


--  Monthly SLA Trend
SELECT MONTH(
           STR_TO_DATE(LEFT(`Created time`,19), '%Y-%m-%d %H:%i:%s')
       ) AS month_number,
       `SLA For Resolution`,
       COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY month_number, `SLA For Resolution`
ORDER BY month_number;


-- Open Ticket Count
SELECT COUNT(*) AS open_tickets
FROM technical_support_all
WHERE Status = 'Open';

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT `Ticket ID`) AS unique_tickets
FROM technical_support_all;

SELECT
    COUNT(*) AS total_rows,
    COUNT(`Ticket ID`) AS non_null_ticket_ids,
    COUNT(DISTINCT `Ticket ID`) AS unique_ticket_ids
FROM technical_support_all;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT `Ticket ID`) AS unique_ticket_ids
FROM technical_support_all;

SELECT
    `SLA For Resolution`,
    COUNT(*) AS ticket_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM technical_support_all
GROUP BY `SLA For Resolution`
ORDER BY ticket_count DESC;

SELECT
    `SLA For first response`,
    COUNT(*) AS ticket_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM technical_support_all
GROUP BY `SLA For first response`
ORDER BY ticket_count DESC;

SELECT
    Priority,
    `SLA For Resolution`,
    COUNT(*) AS ticket_count
FROM technical_support_all
GROUP BY
    Priority,
    `SLA For Resolution`
ORDER BY
    Priority,
    ticket_count DESC;

SELECT
    Topic,
    COUNT(*) AS total_tickets,
    SUM(
        CASE
            WHEN `SLA For Resolution` = 'SLA Violated'
            THEN 1
            ELSE 0
        END
    ) AS violated_tickets,
    ROUND(
        SUM(
            CASE
                WHEN `SLA For Resolution` = 'SLA Violated'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS violation_percentage
FROM technical_support_all
GROUP BY Topic
ORDER BY violation_percentage DESC;

SELECT
    Topic,
    COUNT(*) AS total_tickets,
    SUM(
        CASE
            WHEN `SLA For Resolution` = 'SLA Violated'
            THEN 1
            ELSE 0
        END
    ) AS violated_tickets,
    ROUND(
        SUM(
            CASE
                WHEN `SLA For Resolution` = 'SLA Violated'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS violation_percentage
FROM technical_support_all
GROUP BY Topic
ORDER BY violation_percentage DESC;

SELECT
    Topic,
    COUNT(*) AS total_tickets,
    SUM(
        CASE
            WHEN `SLA For Resolution` = 'SLA Violated'
            THEN 1
            ELSE 0
        END
    ) AS violated_tickets,
    ROUND(
        SUM(
            CASE
                WHEN `SLA For Resolution` = 'SLA Violated'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS violation_percentage
FROM technical_support_all
GROUP BY Topic
ORDER BY violation_percentage DESC;


SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                STR_TO_DATE(
                    LEFT(`Created time`, 19),
                    '%Y-%m-%d %H:%i:%s'
                ),
                STR_TO_DATE(
                    LEFT(`First response time`, 19),
                    '%Y-%m-%d %H:%i:%s'
                )
            )
        ) / 3600,
        2
    ) AS average_first_response_hours
FROM technical_support_all
WHERE `Created time` IS NOT NULL
  AND `First response time` IS NOT NULL
  AND `Created time` <> CONCAT(CHAR(92), 'N')
  AND `First response time` <> CONCAT(CHAR(92), 'N');
  
  SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                STR_TO_DATE(
                    LEFT(`Created time`, 19),
                    '%Y-%m-%d %H:%i:%s'
                ),
                STR_TO_DATE(
                    LEFT(`Resolution time`, 19),
                    '%Y-%m-%d %H:%i:%s'
                )
            )
        ) / 3600,
        2
    ) AS average_resolution_hours
FROM technical_support_all
WHERE `Created time` IS NOT NULL
  AND `Resolution time` IS NOT NULL
  AND `Created time` <> CONCAT(CHAR(92), 'N')
  AND `Resolution time` <> CONCAT(CHAR(92), 'N');
  
  SELECT
    COUNT(*) AS open_tickets
FROM technical_support_all
WHERE Status = 'Open';
 
 SELECT *
FROM technical_support_all
WHERE Status = 'Open';

SELECT
    Topic,
    COUNT(*) AS open_ticket_count
FROM technical_support_all
WHERE Status = 'Open'
GROUP BY Topic
ORDER BY open_ticket_count DESC;

SELECT
    Priority,
    COUNT(*) AS total_tickets,
    SUM(
        CASE
            WHEN `SLA For Resolution` = 'Within SLA'
            THEN 1
            ELSE 0
        END
    ) AS within_sla,
    SUM(
        CASE
            WHEN `SLA For Resolution` = 'SLA Violated'
            THEN 1
            ELSE 0
        END
    ) AS sla_violated,
    ROUND(
        SUM(
            CASE
                WHEN `SLA For Resolution` = 'SLA Violated'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS violation_percentage
FROM technical_support_all
GROUP BY Priority
ORDER BY violation_percentage DESC;