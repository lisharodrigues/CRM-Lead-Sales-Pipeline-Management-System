-- CRM Lead & Sales Pipeline Management System (fictional portfolio case study)
-- Assumed table: crm_leads. Adapt field/table names to your database.

-- 1. Lead counts by status
SELECT lead_status, COUNT(DISTINCT lead_id) AS total_leads
FROM crm_leads
GROUP BY lead_status
ORDER BY total_leads DESC;

-- 2. Lead conversion rate: Converted Leads / Total Leads * 100
SELECT
  100.0 * COUNT(DISTINCT CASE WHEN lead_status = 'Converted' THEN lead_id END)
  / NULLIF(COUNT(DISTINCT lead_id), 0) AS lead_conversion_rate_pct
FROM crm_leads;

-- 3. Lead volume and converted leads by source
SELECT lead_source,
       COUNT(DISTINCT lead_id) AS total_leads,
       COUNT(DISTINCT CASE WHEN lead_status = 'Converted' THEN lead_id END) AS converted_leads,
       100.0 * COUNT(DISTINCT CASE WHEN lead_status = 'Converted' THEN lead_id END)
         / NULLIF(COUNT(DISTINCT lead_id), 0) AS conversion_rate_pct
FROM crm_leads
GROUP BY lead_source
ORDER BY converted_leads DESC;

-- 4. Executive-wise lead outcomes
SELECT assigned_executive,
       COUNT(DISTINCT lead_id) AS total_leads,
       COUNT(DISTINCT CASE WHEN lead_status = 'Qualified' THEN lead_id END) AS qualified_status_count,
       COUNT(DISTINCT CASE WHEN lead_status = 'Converted' THEN lead_id END) AS converted_leads
FROM crm_leads
GROUP BY assigned_executive
ORDER BY converted_leads DESC;

-- 5. Lost reasons
SELECT lost_reason, COUNT(DISTINCT lead_id) AS lost_leads
FROM crm_leads
WHERE lead_status = 'Lost'
GROUP BY lost_reason
ORDER BY lost_leads DESC;

-- 6. Proposed overdue follow-ups (exclude closed outcomes)
SELECT lead_id, lead_name, company_name, assigned_executive, next_follow_up_date
FROM crm_leads
WHERE next_follow_up_date < CURRENT_DATE
  AND lead_status NOT IN ('Converted', 'Lost')
ORDER BY next_follow_up_date;
