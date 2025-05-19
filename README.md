# DataAnalytics-Assessment
Question 3
This SQL query is designed to retrieve a list of inactive savings or investment plans from a database, along with relevant metadata like owner, type, and last transaction date.
Find all savings or investment plans that:
•	Have no transaction in the past 365 days, or
•	Have never had a transaction at all.
FROM Clause and Joins
•	We will be selecting from the plans_plan table (aliased as p), which holds plan information.
•	left join the savings_savingsaccount table (sa), which holds transactions linked to a plan via plan_id.
o	LEFT JOIN ensures that even plans without any transactions are included.
SELECT Clause
•	plan_id: The ID of the plan.
•	owner_id: The ID of the user who owns the plan.
•	type: Derived from flags in the plans_plan table:
•	If it's a fund: "Savings".
•	If it's a regular savings plan: "Investment".
•	Otherwise: "Other" (though such cases are excluded by the WHERE clause below).
•	last_transaction_date: Most recent transaction date for the plan.
•	inactivity_days: Number of days since the last transaction (or null if never had one).
WHERE Clause
•    Filters out deleted plans (is_deleted != 1).
•    Only includes plans that are either:
•	A fund (is_a_fund = 1), or
•	A regular savings plan (is_regular_savings = 1).
GROUP BY Clause
•	Groups results by plan and owner, allowing aggregate functions like MAX() to work.
•	Also includes p.is_a_fund and p.is_regular_savings to support the CASE logic in the SELECT.
HAVING Clause
Only includes plans that:
•	Haven’t had a transaction in the last 365 days, or
•	Have never had a transaction (i.e., MAX(transaction_date) is NULL).
