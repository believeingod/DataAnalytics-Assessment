USE `adashi_staging`;

/* Write a query to find customers with at least one funded savings plan AND one 
funded investment plan, sorted by total deposits. */

WITH Savings AS (
    SELECT owner_id, SUM(confirmed_amount) / 100 AS total_deposits_Naira
    FROM savings_savingsaccount
    WHERE plan_id IS NOT NULL
    GROUP BY owner_id
),
Plans AS (
    SELECT owner_id,
           SUM(is_regular_savings = 1) AS savings_count,
           SUM(is_a_fund = 1) AS investment_count
    FROM plans_plan
    GROUP BY owner_id
)
SELECT
    s.owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    p.savings_count,
    p.investment_count,
    s.total_deposits_Naira
FROM Savings s
JOIN Plans p ON s.owner_id = p.owner_id
JOIN users_customuser u ON s.owner_id = u.id
WHERE p.savings_count >= 1 AND p.investment_count >= 1
ORDER BY s.total_deposits_Naira DESC;

