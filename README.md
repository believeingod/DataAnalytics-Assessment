# DataAnalytics-Assessment

Question 1:
This SQL query retrieves a profile of users who have both savings and investment plans, along with their total deposits, plan counts, and full names, sorted by how much they’ve deposited.
CTE 1: Savings
Purpose:
•	Summarizes how much each user has deposited (in kobo, converted to Naira by dividing by 100).
•	Only includes deposits that are linked to a plan.
Output:
•	owner_id: ID of the user.
•	total_deposits_Naira: Total confirmed deposits made by the user, in Naira.
CTE 2: Plans
Purpose:
•	Counts the number of plans each user has:
o	savings_count: How many plans are marked as regular savings.
o	investment_count: How many are marked as funds (i.e., investments).
Trick:
•	SUM(is_regular_savings = 1) works because SQL treats the boolean result of (is_regular_savings = 1) as 1 (true) or 0 (false), so summing them gives the count.
Main Query
Purpose:
•	Joins:
o	Savings with Plans using owner_id.
o	Then joins with the users_customuser table to get the user's name.
•	Fetches:
o	The user ID
o	Full name (first + last)
o	Number of savings and investment plans
o	Total deposits in Naira
Filter Condition
Meaning:
•	Only includes users who have at least one savings plan and at least one investment plan.
Order
Effect:
•	Sorts the result by total deposits, from highest to lowest.
Final Output:
Each row in the result represents a user who:
•	Has both a savings and investment plan
•	Has made deposits into one or more plans
•	Includes their:
o	ID
o	Full name
o	Count of each plan type
o	Total deposit amount (in Naira)

Queston 2: 
This SQL query analyzes customer transaction behavior by categorizing users based on the average number of transactions per month they make.
CTE 1: MonthlyTransactions
Purpose:
•	Groups all transactions by month and customer.
•	Counts how many transactions each customer makes per month.
CTE 2: CustomerMonthlyAvg
Purpose:
•	Calculates the average number of transactions per month for each customer.
How:
•	SUM(num_transactions) gives total transactions for the customer.
•	COUNT(DISTINCT transaction_month) gives the number of months with activity.
•	Division gives average transactions per active month.
Final Query
Purpose:
•	Groups users into 3 frequency tiers:
o	High Frequency: ≥ 10 transactions/month
o	Medium Frequency: 3–9 transactions/month
o	Low Frequency: < 3 transactions/month
•	For each category:
o	Counts how many customers fall into it.
o	Calculates the average transaction frequency within the group.


Question 3: 
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


Question 4: 
This SQL query focuses on calculating the tenure and an estimated customer lifetime value (CLV) for users based on their transaction history and signup date.
CTE 1: MonthlyTransactions
What it does:
•	For each customer (owner_id), it calculates:
o	tenure_months: Number of months between their first and last transaction (inclusive).
	TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1
o	total_transactions: Total number of transactions made by the customer.
Why add 1?
•	To count both the first and last month inclusively (e.g., Jan to Mar = 3 months).
CTE 2: UserTenure
What it does:
•	For each user, calculates:
o	Their tenure since signup in months (from account creation to today).
o	Their full name as a concatenation of first and last names.
Final SELECT and JOIN
What’s happening:
•	Join the user signup info (UserTenure) with transaction data (MonthlyTransactions) on customer_id.
•	Use COALESCE to handle missing data:
o	For tenure_months, if no transactions exist, use signup tenure, or default to 1 month.
o	For total_transactions, if none exist, default to 0.
•	Calculate estimated CLV (Customer Lifetime Value) using this formula:
o	total_transactions / tenure_months: average transactions per month.
o	Multiply by 12 to annualize.
o	Multiply by 0.1 (likely a monetary value per transaction or some coefficient for CLV).
•  Cast the CLV as decimal with 2 decimal places.
•  Order the results by estimated_clv descending highest CLV first.





